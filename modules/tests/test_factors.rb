require 'test/unit'
require 'modules/factors'
#require 'modules/fast_factors'
class TestFactors < Test::Unit::TestCase

#const_set(:Factors,FastFactors)

def test_factors_prime
	fac = Factors.new
	assert_equal [2], fac.factors(2)
	assert_equal [3], fac.factors(3)
	assert_equal [5], fac.factors(5)
	assert_equal [7], fac.factors(7)
end

def test_factors_even
	fac = Factors.new
	assert_equal [2,2], fac.factors(4)
	assert_equal [2,3], fac.factors(6)
	assert_equal [2,2,2], fac.factors(8)
	assert_equal [2,5], fac.factors(10)
	assert_equal [2,2,3], fac.factors(12)
	assert_equal [2,7], fac.factors(14)
end

def test_factors_odd
	fac = Factors.new
	assert_equal [3,3], fac.factors(9)
	assert_equal [3,5], fac.factors(15)
	assert_equal [3,7], fac.factors(21)
	assert_equal [5,5], fac.factors(25)
	assert_equal [3,3,3], fac.factors(27)
	assert_equal [5,7], fac.factors(35)
	assert_equal [3,3,5], fac.factors(45)
	assert_equal [7,7], fac.factors(49)
	assert_equal [5,11], fac.factors(55)
	assert_equal [3,3,7], fac.factors(63)
	assert_equal [3,5,5], fac.factors(75)
	assert_equal [3,3,3,3], fac.factors(81)
end

def test_factors_large
	fac = Factors.new
	assert_equal [3,3,11], fac.factors(99)
	assert_equal [2,2,2,2,2,2,2], fac.factors(128)
	assert_equal [2,3,47], fac.factors(282)
end

end
