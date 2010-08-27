class DynamicPrimes2

	def initialize(i)
		@i = i
#		@@primes ||= [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47]
		@@primes ||= [2,3,5,7,11,13,17,19]
	end
	def primes
		p = []
		last = 3
		@@primes.find {|f|
			if f <= @i then
				p << f
				last = f
				false
			else
				true
			end
		}
	
		j = [3,last + 2].max
		stop = nil
		puts p.inspect
		puts "target #{@i}"
		stop = Math.sqrt @i
		while j <= @i do
			if p.find{|f|
				if f < stop then
					j % f == 0 #sieve it
				else
					break	
				end
			}.nil? then
				@@primes << j
				p << j
			end
			j += 2
		end
		p
	end
end


if __FILE__ == $0 then
		
end
