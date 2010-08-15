require 'adaptable_test'
require 'library'

class TestLibrary < AdaptableTest
	
	def default_subject; Library; end

	def test_is_test_empty
		lib = subject.new
		lib.depends(d = Depends.new)
		begin
			lib.is_test?(:RandomSymbol_30958woeh)
			fail "expected a RuntimeError due to #{subject} not knowing :RandomSymbol_30958woeh"
		rescue RuntimeError => a
		end
		d.depends_on(:TestAdaptableTest,'./tests/test_adaptable_test.rb')

		assert lib.is_test?(:TestAdaptableTest)

		d.depends_on(:TestPrimes,'./modules/tests/test_primes.rb')
		assert lib.is_test?(:TestPrimes)
		d.depends_on(:Primes,'./modules/primes.rb')
		assert_equal false, lib.is_test?(:Primes), "expected Primes not to be a test"

		assert lib.test(:TestPrimes,:Primes)
	
		assert_equal false, lib.test(:TestPrimes,:TestPrimes)
	end
	def test_add
		lib = subject.new
		lib.depends(d = Depends.new)
		d.depends_on(:TestAdaptableTest,'./tests/test_adaptable_test.rb')
		
		lib.add_test(:TestAdaptableTest)
		assert_equal [:TestAdaptableTest],lib.passes[:TestAdaptableTest]
		d.depends_on(:TestPrimes,'./modules/tests/test_primes.rb')

		lib.add(:TestPrimes)
		assert_equal [:TestAdaptableTest,:TestPrimes],lib.passes[:TestAdaptableTest]
		d.depends_on(:Primes,'./modules/primes.rb')
		lib.add(:Primes)
		assert_equal [:Primes],lib.passes[:TestPrimes]
		
	end
end

Mini::Test.autorun
