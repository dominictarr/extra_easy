
require 'modules/primes'
#calculate factors slowly.
class FastFactors 

#def is_prime? (f)
#	Primes.new(f*f).primes.include? f
#end
	def next_factor(f)
		@primes.find{|p| f % p == 0} 
		#this is better than factors but to be
		#even better, it should only pass over
		#@primes once
	end
def factors (f)
	@primes = Primes.new(f).primes
	fac =[]
		while !(@primes.include? f) do
			f2 = next_factor(f)
			fac << f2
			f = f / f2
		end
		fac << f
end

end
