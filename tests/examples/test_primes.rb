 puts $:
 
 require "test/unit"
 require "primes/primes"
 
 class TestPrimes < Test::Unit::TestCase
 
	def initialize (x,klass = Primes )
				
	@pclass = klass;
	super(x)
#		puts "TESTPRIMES INITED :" + pclass.to_s
	end
	
	#~ def initialize (s)
		#~ @pclass  = Primes
	#~ end

	def pclass 
		@pclass
		end
 
 def test_primesMethod ()
	c = pclass.new(1)
	assert_not_nil(c.methods.find('primes'))
	 end


def assert_underN(n,pn)
	c = pclass.new(n)
	#puts "UNDER #{n} #{c}"
	assert_equal(pn,c.primes)
 end

 def test_under0
	assert_underN(0,[])
 end

 def test_under2
	assert_underN(2,[2])
 end

 #~ def test_fail
	#~ assert(false)
 #~ end

 #~ def test_error
	#~ 1 / 0;
 #~ end


def test_under10
#	c = Primes.new(10)
#	pn = [2,3,5,7]
#	assert_equal(pn,c.primes)

	assert_underN(10,[2,3,5,7])
end
 def test_under20
	 #puts self.class.inspect + self.inspect
	assert_underN(20,[2,3,5,7,11,13,17,19])
end
end




#puts  TestPrimes.new("test_fail",Primes)