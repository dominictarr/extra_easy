require 'dm_test'
require 'model_test'
require 'library_db'



class TestLibrary < ModelTest
	
	def default_subject; LibraryDb; end

	def test_is_test_empty
		lib = subject.new
	#	lib.depends(d = Depends.new)
		begin
			lib.is_test?(:RandomSymbol_30958woeh)
			fail "expected a RuntimeError due to #{subject} not knowing :RandomSymbol_30958woeh"
		rescue RuntimeError => a
		end
#		lib.add_depends(:TestAdaptableTest,'./tests/test_adaptable_test.rb')

		assert lib.is_test?(:TestAdaptableTest)

		lib.add_depends(:TestPrimes,'./modules/tests/test_primes.rb')
		assert lib.is_test?(:TestPrimes)
		lib.add_depends(:Primes,'./modules/primes.rb')
		assert_equal false, lib.is_test?(:Primes), "expected Primes not to be a test"

		assert lib.test(:TestPrimes,:Primes)
	
		assert_equal false, lib.test(:TestPrimes,:TestPrimes)
	end
	def test_add
		lib = subject.new
		#lib.depends(d = Depends.new)
	#	lib.add_depends(:TestAdaptableTest,'./tests/test_adaptable_test.rb')
		
		lib.is_test?('TestAdaptableTest')
		assert_equal [:TestAdaptableTest],lib.passes[:TestAdaptableTest]
		lib.add_depends(:TestPrimes,'./modules/tests/test_primes.rb')

		lib.add(:TestPrimes)
		assert_equal [:TestAdaptableTest,:TestPrimes],lib.passes[:TestAdaptableTest]
		lib.add_depends(:Primes,'./modules/primes.rb')
		lib.add(:Primes)
		assert_equal [:Primes],lib.passes[:TestPrimes]

	end
end

Mini::Test.autorun
