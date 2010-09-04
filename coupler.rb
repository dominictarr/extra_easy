require 'net/http'
require 'yaml'

module Coupler

	def couple(test)
		url = URI.parse("http://meta-modular.com/couple/#{test.to_s}")
		ary = YAML::load(Net::HTTP.get(url))
		eval ary[1] #require code
		eval ary[0].to_s #init class
	end

end
