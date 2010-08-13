#require 'library'
require 'net/http'
require 'yaml'

module Coupler

	def to_klass (sym)
		puts "eval #{sym.to_s}"
		eval sym.to_s
	end

	def is_ident? (klass)
		klass.is_a? Symbol or klass.is_a? String
	end

	#require 'library'
	def load (test)
		url = URI.parse("http://localhost:4567/?test=#{test.to_s}")
		ary = YAML::load(Net::HTTP.get(url))
		eval ary[1] #require code
		eval ary[0].to_s #init class
	end
	def couple(test)
		return load(test)
		#load the class from the LocalLibrary
		#test = to_key(test)
		#return LocalLibrary.couple(test)
	end

	def to_key (test)
		unless is_ident? test then
			test = test.name.to_sym
		else 
			test = test.to_sym
		end
		test 
	end	
end

