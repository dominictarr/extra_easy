class Depends

	def depends
		@dep ||={}
	end
	def depends_on(klass,*requires)
		raise "expected #{klass} to be symbol" unless klass.is_a? Symbol
		requires.each_with_index{|r,i|
			raise "expected #{r}, (#{i}th arg) to be a String" unless r.is_a? String
		}
		@dep ||={}
		@dep[klass] ||=[]
		requires.each{|e|
			@dep[klass] << e
		}
		puts @dep[klass].inspect
	end
	def requires(klass)
		raise "expected #{klass} to be symbol" unless klass.is_a? Symbol
		@dep[klass].each{|r|
			puts "require '#{r}'"
			puts require r
		} if @dep[klass]
		
		puts "eval '#{klass}'"
		eval klass.to_s
	end
end
