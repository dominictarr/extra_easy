require 'modules/primes'

class SmartPrimes < Primes

	def initialize (j)
	#generate a list of primes lower than n
	#using sieve method...
	n = []
	j.times { |i| n << (i + 1)}

	k = 2
	max = Math.sqrt(n.length)
		while k <= max
			l = k * 2 - 1
			while l < n.length
				n[l] = 0
				l += k
				
				
			end
			k += 1
		end
	n.delete 1
	@primes = n.find_all{|m| m != 0}
	end
end


#puts '[' + SmartPrimes.new(10000).primes.join(',') + ']'

