require 'quick_attr'
require 'depends'
require 'tester'

class Library
	extend QuickAttr
	quick_attr :depends, :test_for_test, :passes
	quick_array :tests,:subjects

	def initialize 
		test_for_test :TestAdaptableTest
		depends Depends.new
		passes Hash.new
	end
	def add_depends(klass,file)
		depends.depends[klass] ||= []
		depends.depends[klass] << file unless depends.depends[klass].include? file
	end

	def is_test?(test)
		raise "test_for_test is nil" unless test_for_test
		test(test_for_test,test)
	end

	def depends_for (*args)
		a = []
		args.each{|e|
		raise "missing dependency for #{e.inspect}" unless depends.depends[e]
			depends.depends[e].each{|x|
			a << x unless a.include? x
			}
		}
		a
	end	
	
	def test(test,sub)
#		if passes[test] and passes[test].include? sub then
#			return true
#		end
		
		r =  Tester.new.
				test(test).
				klass(sub).
				requires(*depends_for(test,sub)).
				run_sandboxed
				
		if r[:result] then
			passes Hash.new unless passes
			passes[test] ||= []
			passes[test] << sub unless passes[test].include? sub
		end
		r[:result]

	end
	
	def add_test(t)
		return unless is_test?(t)
		tests << t
		passes[t] ||= []
		subjects.each {|k|
			if test(t,k) then
				passes[t] << k unless passes[t].include? k
			end
		}
	end
	
	def add(subject)
		subjects << subject 
		add_test(subject)
		puts "tests : #{tests.inspect}"
		puts subject.inspect
		
		tests.each {|t|
			if test(t,subject) then
				passes[t] << subject unless passes[t].include? subject
			end
		}		
	end

end
