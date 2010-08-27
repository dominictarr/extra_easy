require 'modules/primes'

class SmartPrimes4

	def initialize (j)
	#generate a list of primes lower than n
	#using sieve method...
		@j = j
	end
	
	def primes 
	return [] if @j < 2
	n = []

	primes = [2]
	k = 3
	puts @j
		while k <= @j
			f = 0
			#interesting
			while f < primes.length and #don't go over end of array
				np = (k % primes[f] != 0) and  #find if a number isn't prime
				f * f < k #you don't need to check any numbers above k.srqt
				f += 1
			end
			primes << k if np
			k += 2
		end
		primes
	end
end


#puts '[' + SmartPrimes.new(10000).primes.join(',') + ']'

