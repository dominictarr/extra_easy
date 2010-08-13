class TooCleverPrimes 
@primes = []

	def initialize (j)

	# a single pass method to find primes.
	# iterate through k = 3 upto up to j,

	#should be called 'too clever' primes. this is slower than primes.rb
		
	#~ /*
	#~ there should be a way to iterate through current primes to get non next prime..
	
	#~ by building the factor tree...
	
	#~ 2*2 = 4 
	#~ 4 - 1 = 3
	#~ 2*3 = 6
	#~ 6 - 1 = 5
	#~ 2*2*2 = 8
	#~ 8 - 1 = 7
	#~ 3*3 = 9
	
	#~ a little more complicated than I thought!
	#~ maybe that wont work at all.
	#~ a better way might be to stop sieving when the siev gets to  j.sqrt
	
	#~ */
		@primes = []
		k = 3
		
		if j >= 2
			@primes = [2]
		end

		while( k <= j)
			if (! @primes.find {|x| k. modulo(x) == 0})
				@primes << k
			end
		k += 2;#don't check even numbers...
		end
	end
	def primes	
		@primes
	end

end


#puts '[' + TooCleverPrimes.new(10000).primes.join(',') + ']'

