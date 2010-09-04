require 'adaptable_test'
require 'tester'
require 'yaml'

class TestTester < AdaptableTest
#extend TestSL

	def default_subject; Tester; end

	def test_run_instruction_require
		report = subject.new.test(:'TestPrimes').
					klass(:Primes).
					requires('modules/tests/test_primes.rb','modules/primes.rb').
					run_sandboxed
		

		assert report[:pass], "expected non nil result #{report[:result].inspect}"

		report = subject.new.test(:'TestPrimes').
					klass(:BrokePrimes).
					requires('modules/tests/test_primes.rb','modules/broke_primes.rb').
					run_sandboxed

		assert !report[:pass],
		#more meaningful report which states which methods are passed and failed

		report = subject.new.test(:'TestPrimes').
					klass(:SmartPrimes).
					requires('modules/tests/test_primes.rb','modules/smart_primes.rb').
					run_sandboxed
			
		assert report[:pass]
		begin 
			eval "SmartPrimes"
			assert false, "expected a NameError"
		rescue NameError => n		
		end
		
		report = subject.new.test(:'TestPrimes').
					klass(:TooCleverPrimes).
					requires('modules/tests/test_primes.rb','modules/too_clever_primes.rb').run_sandboxed
			
		assert report[:pass]
		begin 
			eval "TooCleverPrimes"
			assert false, "expected a NameError"
		rescue NameError => n		
		end

		report = subject.new.test(:'TestPrimes').
					klass(:BrokePrimes).
			 		requires('modules/tests/test_primes.rb','modules/broke_primes.rb').run_sandboxed
			
		assert !report[:pass]

	end
	
	def test_simple
	
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
		
		r = subject.new.test(:TestSimple).klass(:TestAdaptableTest).headers([test_code]).requires('tests/test_adaptable_test').run_sandboxed
		assert r, "Expected TestSimple.test(TestAdaptableTest) to give results"
		#fails because a test.new(..) has arity=1
		
		r = subject.new.test(:TestAdaptableTest).klass(:TestSimple).headers([test_code]).requires('tests/test_adaptable_test').run_sandboxed
		assert r, "Expected TestSimple.test(TestAdaptableTest) to give results"
		#assert subject::PASS,r[:result]
		assert r[:pass]
	end
	def test_simple2
		test_code = %{
			class TestSimple < AdaptableTest
				def default_subject; nil; end 
				def test_initialize
					assert subject.new, "#{subject} should have .new method"
					assert_equal subject, subject.new.class, "#{subject}.new.class returns #{subject}"
				end
			end
		}
		test_adaptable_test = File.open('tests/test_adaptable_test.rb').read
		
		r = subject.new.test(:TestSimple).klass(:TestAdaptableTest).headers([test_code,test_adaptable_test]).run_sandboxed
		assert r, "Expected TestSimple.test(TestAdaptableTest) to give results"
		#fails because a test.new(..) has arity=1
		
		r = subject.new.test(:TestAdaptableTest).klass(:TestSimple).headers([test_code]).requires('tests/test_adaptable_test').run_sandboxed
		assert r, "Expected TestSimple.test(TestAdaptableTest) to give results"

		assert r[:pass]
	end
end

Mini::Test.autorun
