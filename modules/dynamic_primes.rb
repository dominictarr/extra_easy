class DynamicPrimes

	def initialize(i)
		@i = i
		@@primes ||= [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47]
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
	
		j = [3,last].max
		while j <= @i do
			if p.find{|f|
				j % f == 0
			}.nil? then
				p << j
			end
			j += 2
		end
		p
	end
end


if __FILE__ == $0 then
		
end
