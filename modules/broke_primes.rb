class BrokePrimes
PRIMES = [2,3,5,7,11,13]
def initialize (x); 
@primes = []
	PRIMES.each {|it| if it <= x then @primes << it; end}
	end
def primes; @primes; end
end


