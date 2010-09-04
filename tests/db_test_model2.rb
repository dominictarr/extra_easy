require 'dm_prod'
require 'model2'
require 'model_test'
require 'tester'

class TestModel2 < ModelTest
	def default_subject; NilClass; end

	def test_klass
		rb = RbFile.create(:code_hash => 13459238, :code => "whatever")
		test_x = Klass.create(:name => 'TestX', :rb_file =>  rb)
		
		x = Klass.create(:name => 'X', :rb_file =>  rb)

		assert test_x.saved?
		assert x.saved?

		tr = TestRun.create(:klass => x, :test => test_x, :pass => true)
		assert tr.saved?

		TestRunMethod.create(:test_run => tr, :method_name => "test_hello")

		assert_equal [tr], test_x.this_test_runs
		assert_equal [tr], x.test_runs
		
		assert_equal [x], test_x.klasses_passed
		assert_equal [test_x], x.tests_passed

		y = Klass.create(:name => 'Y', :rb_file =>  rb)
		test_y = Klass.create(:name => 'TestY', :rb_file => rb)

		assert y.saved?
		tr2 = TestRun.create(:klass => y, :test => test_x, :pass => false)
		tr3 = TestRun.create(:klass => x, :test => test_y, :pass => true)
		assert tr2.saved?
		assert tr3.saved?
		
		assert_equal [tr2], y.test_runs
		assert [tr,tr2], TestRun.all(:test => test_x)
		assert [tr,tr3], TestRun.all(:klass => x)
		x.reload
		assert_equal TestRun.all(:klass => x), x.test_runs
		test_x.reload
		assert_equal [tr,tr2], test_x.this_test_runs

		assert_equal [test_x,test_y], x.tests_passed
		assert_equal [], y.tests_passed
		assert_equal [x], test_x.klasses_passed
	end
	
	def dtest_is_test
				tat = Klass.first(:name => :TestAdaptableTest)
				assert_equal true, tat.is_test
				assert tat.klasses_passed.include? tat	 
				tr = TestRun.first(:test => tat, :klass => tat)
				assert true, tr.pass
	end
	
	def test_parse
		r = RbFile.load_rb("modules/tests/test_primes.rb")
		assert r.code
		assert r.code.include? "TestPrimes"

		klasses =  r.parse

		assert_equal 1, klasses.length 

		klasses.first.code == r.code
	end
	
	def test_run_tests
		tat = Klass.first(:name => :TestAdaptableTest)
		tp = Klass.create(:name => :TestPrimes, :rb_file => RbFile.load_rb("modules/tests/test_primes.rb"))
		
		p = Klass.create(:name => :Primes, :rb_file => RbFile.load_rb("modules/primes.rb"))
		sp = Klass.create(:name => :SmartPrimes, :rb_file => RbFile.load_rb("modules/smart_primes.rb"))
		tp.run_all_tests
		p.run_all_tests
		sp.run_all_tests
		tat.reload
		
		assert tp.tests_passed.include? tat
		assert tat.klasses_passed.include? tp
		
		assert p.tests_passed.include? tp
		assert tp.klasses_passed.include? p
		assert tp.klasses_passed.include? sp
	end
	
	def dont_test_parse_from_rb_file
		klasses = []
		puts "PARSE .rb ============================="
		klasses += RbFile.load_rb("modules/tests/test_primes.rb").parse
		klasses += RbFile.load_rb("modules/primes.rb").parse
		klasses += RbFile.load_rb("modules/smart_primes.rb").parse
		puts "PARSE .rb END ============================="
	
		tp = Klass.first(:name => :TestPrimes)
		p = Klass.first(:name => :Primes)
		sp = Klass.first(:name => :SmartPrimes)
		assert tp
		assert p
		assert sp

		assert TestRun.first(:klass => tp, :test => {:name => :TestAdaptableTest}).pass, "expected TestPrimes to pass TestAdaptableTest"
		

		assert tr = TestRun.first(:klass => p, :test => tp)
		assert tr.pass
		
		assert_equal Tester::PASS, tr.result

		assert_equal [p,sp], tp.klasses_passed
		
		tr = TestRun.first(:test => tp, :klass => p)
		assert tr.pass

		tr.test_run_methods.each{|e|
			assert_equal "pass",e.result
		}
		assert 4 < tr.test_run_methods.length

		klasses += RbFile.load_rb("modules/broke_primes.rb").parse

		bp = Klass.first(:name => :BrokePrimes)

		btr = bp.test_runs.first(:test => tp)
		assert_equal bp, btr.klass
		assert_equal tp, btr.test
		assert_equal false,btr.pass
		
		#for some fucking weird reason the failing test run method evaporates...
		assert TestRunMethod.all(:result => "Fail.").length > 0,"there should be a \"Fail.\" TestRunMethod somewhere"
		assert btr.test_run_methods.find{|f|
			f.result == "Fail." or f.result == "ERROR!"
		}, "expected to find at least one failing test method for BrokePrimes"
		
	end

	def dont_test_parse_from_rb_file_werid
		klasses = []
		klasses += RbFile.load_rb("modules/tests/test_primes.rb").parse
		klasses += RbFile.load_rb("modules/primes.rb").parse
		klasses += RbFile.load_rb("modules/broke_primes.rb").parse
		klasses += RbFile.load_rb("modules/smart_primes.rb").parse
	
		tp = Klass.first(:name => :TestPrimes)
		p = Klass.first(:name => :Primes)
		sp = Klass.first(:name => :SmartPrimes)
		
		tr = TestRun.first(:test => tp, :klass => p)

		bp = Klass.first(:name => :BrokePrimes)

		btr = bp.test_runs.first(:test => tp)

		assert_equal bp, btr.klass
		assert_equal tp, btr.test
		assert_equal false,btr.pass
		
		#for some fucking weird reason the failing test run method evaporates...
		#TestRunMethod's wernt saving becase the message was too long so save as a string?
		#when i changed the type to a Text it worked.
		#ofcourse i expect it to save! DataMapper just fails silently. disapointing.
		assert TestRunMethod.all(:result => "Fail.").length > 0,"there should be a \"Fail\" TestRunMethod somewhere"
		
	 assert btr.test_run_methods.find{|f|
			f.result == "Fail." or f.result == "ERROR!"
		}, "expected to find at least one failing test method for BrokePrimes"
	end

	
	def test_auto_join
	
		t = Thing.create()
		w = Whatever.create()
		
		t.whatevers << w
		t.save
		assert_equal [t], w.things

		t2 = Thing.create()
		w2 = Whatever.create()
		
		ThingWhatever.create(:thing => t2, :whatever => w2)
		assert_equal [t2], w2.things
		assert_equal [w2], t2.whatevers
		ThingWhatever.create(:thing => t2, :whatever => (w3 = Whatever.create))
		t2.reload
		assert_equal [w2,w3], t2.whatevers
	end
	
	
	def test_updating_code
		#does test runs etc behave right when code changes?
		
		test_code = %{
		class TestSimple < AdaptableTest
			def default_subject; nil; end 
			def test_initialize
				assert subject.new, "#{subject} should have .new method"
				assert_equal subject, subject.new.class, "#{subject}.new.class returns #{subject}"
			end
		end
		#class DefaultSubject; end
		}
		test_klass1 = %{
			class Hello1; end
		}
	
		test_simple_rb = RbFile.load_code(test_code, "test_simple")
		klasses = test_simple_rb.parse
		assert klasses.is_a?(Array), "RbFile.load_code(...).parse to list of classes."
		assert_equal 1,klasses.length
		assert_equal 'TestSimple',klasses[0].name
		test_simple = klasses[0]

		tat = Klass.first(:name => :TestAdaptableTest)

		tr = TestRun.first(:test => tat, :klass => test_simple)

		assert tr
		assert tr.pass
		assert_equal tr.result, Tester::PASS

		tat.run_test(test_simple)	

		test_simple.reload
		assert_equal [tat],test_simple.tests_passed


		test_simple_rb = RbFile.load_code(test_klass1, "hello1")
		klasses = test_simple_rb.parse
		assert klasses.is_a?(Array), "RbFile.load_code(...).parse to list of classes."
		assert_equal 1,klasses.length
		assert_equal 'Hello1',klasses[0].name
		hello1 = klasses[0]
		
		assert_equal [test_simple],hello1.tests_passed

				
	
	end

end

if __FILE__ == $0 then
	Mini::Test.autorun
end
