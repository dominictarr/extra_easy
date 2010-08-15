 require "adaptable_test"
 require "modules/primes"

#  	include TestSL
#  	extend TestSL

 	class TestPrimes < AdaptableTest 
 
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

 	def default_subject; Primes; end
 	
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
	
	def test_under20
		assert_underN(20,[2,3,5,7,11,13,17,19])
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
