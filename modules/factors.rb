
require 'modules/primes'
#calculate factors slowly.
class Factors 

def is_prime? (f)
	Primes.new(f*f).primes.include? f
end
	def next_factor(f)
		n = Primes.new(f).primes
		n.find{|p| f % p == 0} 
	end
def factors (f)
	fac =[]
		while !(is_prime?(f)) do
			f2 = next_factor(f)
			fac << f2
			f = f / f2
		end
		fac << f
end

end
