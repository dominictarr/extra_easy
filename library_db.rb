require 'quick_attr'
require 'depends'
require 'tester'
require 'model'

class LibraryDb
	extend QuickAttr
	quick_attr :depends, :test_for_test
	quick_array :tests,:subjects

	def is_saved? (object)
		puts "saved: #{object.inspect} #{object.saved? ? "saved" :  "NOTSAVE!!!"}"
	end

	def passes
		h = Hash.new

		UnitTest.all.each{|t|

			ks = t.klass.name.to_sym
			h[ks] = []
			 t.test_runs(:pass => true).collect{|p|
				h[ks] << p.klass.name.to_sym
			}
		}
		puts h.inspect
		h
	end

	def initialize 
		# 'TestAdaptableTest'
		test_for_test :TestAdaptableTest
		r = RbFile.load_rb('tests/test_adaptable_test.rb')
		is_saved? r
		tat = Klass.first_or_create(
				:name => 'TestAdaptableTest')
			tat.rb_files = [r]
			tat.save
					is_saved? tat
		is_saved? UnitTest.first_or_create(
				:klass => tat
				)
				puts Klass.all.inspect
	end
	def add_depends(klass,file)
		puts "add #{klass} -> #{file}"
		
		r = RbFile.load_rb(file)
		k = Klass.first_or_create(:name => klass)
		k.rb_files << r
		k.save

	end

	def is_test?(test)
		raise "test_for_test is nil" unless test_for_test

		r = 	test(test_for_test,test)
		add_test(test) if r
		r
	end

	def depends_for (*args)
		a = []
		
		args.each{|e|

		k = nil
		r = []
		raise "don't know klass:  #{e}" if !(k = Klass.first(:name => e.to_s))
		raise "missing dependency for #{e.inspect}" if (r = k.rb_files).empty?
				
			r.each{|rb|
			a << rb unless a.include? rb
			}
		}
		a
	end	
	
	def test(_test,_sub)

		test = UnitTest.first(:klass => {:name => _test})
		sub = Klass.first(:name => _sub.to_s)
		raise "don't know test #{_test}" if test.nil? 
		raise "don't know class #{_sub}" if sub.nil? 

		r =  Tester.new.
				test(test.klass.name).
				klass(sub.name).
				headers(*(sub.rb_files.map{|m| m.code} + test.klass.rb_files.map{|m| m.code})).
				#requires(*depends_for(test.klass.name,sub.name).map{|rb| rb.name}).
				run_sandboxed
				
			tr = TestRun.first_or_create(:unit_test => test, :klass => sub, :pass => r[:result])
			is_saved? tr
			puts "--------------------"			
			puts "#{test.klass.name} -> #{sub.name} == #{r[:result].inspect}"
			puts "--------------------"			

			
#			puts "CREATE TestRun #{tr}"
#			puts tr.unit_test
#			puts tr.unit_test.test_runs.inspect
			raise "can't find test_run #{tr.inspect}" unless test.test_runs.include? tr

#			puts test.test_runs
		r[:result]

	end
	
	def add_test(t)
		ut = UnitTest.first_or_create(:klass => Klass.first(:name => t))
		#puts "CREATE UNIT TEST: #{ut.inspect} (#{ut.klass.name})"
		is_saved? ut
		Klass.all.each {|k|
		test(t,k.name)
		}
	end
	
	def add(subject)
		#subjects << subject 
		is_test?(subject)
		UnitTest.all.each {|t|
			test(t.klass.name,subject)
		}
	end

end
