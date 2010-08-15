class Primes

@primes = []

def primes 
	return @primes
	end

	def initialize (j)
	#generate a list of primes lower than n
	#using sieve method...
	n = []
	j.times { |i| n << (i + 1)}

	k = 2
		while k < n.length
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


#puts '[' + Primes.new(10000).primes.join(',') + ']'

