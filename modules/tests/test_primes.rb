 require "adaptable_test"
 require "modules/primes"
# require "modules/dynamic_primes2"
# require "modules/smart_primes3"

#  	include TestSL
#  	extend TestSL

 	class TestPrimes < AdaptableTest 

#  	def default_subject; Primes; end
  	def default_subject; Primes; end

	def create (*a,&block) 
		subject.new(*a,&block)
	end

#	def initialize (x,klass = Primes )
#	@pclass = klass;
#	super(x)
#		puts "TESTPRIMES INITED :" + pclass.to_s
#	end
	
	#~ def initialize (s)
		#~ @pclass  = Primes
	#~ end

#	def pclass 
#		@pclass
#		end
def assert_not_nil n,m=nil
	assert nil != n, m
end
def assert_underN(n,pn)
	c = subject.new(n)
	#puts "UNDER #{n} #{c}"
	assert_equal(pn,c.primes)
 end

 	
	def test_primes_method
		c = create(1)
		assert_not_nil(c.methods.find('primes'))
	end


	def test_under0 
		assert_underN(0,[])
	end

	def test_under2
		assert_underN(2,[2])
	end
	
	def test_under10
		assert_underN(10,[2,3,5,7])
	end
	
	def test_under_twenty
		assert_underN(20,[2,3,5,7,11,13,17,19])
	end
	def test_under_100
		assert_underN(100,[2,3,5,7,11,13,17,19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97])
	end

	def test_under_500
		assert_underN(500,[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499])
#		assert_underN(100,[2,3,5,7,11,13,17,19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97])
	end
end
#if __FILE__ == $0 then
#	require 'modules/primes'
#	require 'modules/smart_primes'
#	require 'modules/too_clever_primes'
#	require 'modules/broke_primes'
#	require 'library'

#	Library.library.submit(Primes,SmartPrimes, TooCleverPrimes,BrokePrimes)

#	Library.library.submit_test(SafeTest::TestPrimes)
#	Library.library.report

#end

Mini::Test.autorun
