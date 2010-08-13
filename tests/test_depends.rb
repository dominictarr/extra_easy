require 'test/unit'
require 'depends'

class TestDepends < Test::Unit::TestCase 
	def test_simple
		d = Depends.new
		d.depends_on(:Example,'x.rb','y.rb','z.rb')
		begin
			d.requires(:Example)
			raise "expected LoadError"
		rescue LoadError => l
		end
	end
	def test_primes
		d = Depends.new
		d.depends_on(:SmartPrimes,'modules/primes.rb','modules/smart_primes.rb')
		k = d.requires(:SmartPrimes)
		assert_equal 'SmartPrimes',k.name
		
		d.depends_on(:TestFactors,'modules/tests/test_factors.rb','modules/factors.rb')
		k = d.requires(:TestFactors)
		assert_equal 'TestFactors',k.name
	end
end

