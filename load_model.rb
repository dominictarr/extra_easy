

require 'model'

RbFile.load_rb("modules/tests/test_primes.rb")
RbFile.load_rb("modules/primes.rb")
RbFile.load_rb("modules/smart_primes.rb")
RbFile.load_rb("modules/too_clever_primes.rb")

puts RbFile.all.each{|it|
	puts it.name
	puts it.code
	
}

