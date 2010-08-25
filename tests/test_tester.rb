require 'adaptable_test'
require 'tester'
require 'yaml'

class TestTester < AdaptableTest
#extend TestSL

	def default_subject; Tester; end

	def test_run_instruction_require
		report = Tester.new.test(:'TestPrimes').
					klass(:Primes).
					requires('modules/tests/test_primes.rb','modules/primes.rb').
					run_sandboxed
		
		puts report.inspect
		assert report[:pass], "expected non nil result #{report[:result].inspect}"

		report = Tester.new.test(:'TestPrimes').
					klass(:BrokePrimes).
					requires('modules/tests/test_primes.rb','modules/broke_primes.rb').
					run_sandboxed
	puts "REPORT:"
		puts report.inspect
		assert !report[:pass],
		#more meaningful report which states which methods are passed and failed

		report = Tester.new.test(:'TestPrimes').
					klass(:SmartPrimes).
					requires('modules/tests/test_primes.rb','modules/smart_primes.rb').
					run_sandboxed
			
		assert report[:pass]
		begin 
			eval "SmartPrimes"
			assert false, "expected a NameError"
		rescue NameError => n		
		end
		
		report = Tester.new.test(:'TestPrimes').
					klass(:TooCleverPrimes).
					requires('modules/tests/test_primes.rb','modules/too_clever_primes.rb').run_sandboxed
			
		assert report[:pass]
		begin 
			eval "TooCleverPrimes"
			assert false, "expected a NameError"
		rescue NameError => n		
		end

		report = Tester.new.test(:'TestPrimes').
					klass(:BrokePrimes).
			 		requires('modules/tests/test_primes.rb','modules/broke_primes.rb').run_sandboxed
			
		assert !report[:pass]

	end
end

Mini::Test.autorun
