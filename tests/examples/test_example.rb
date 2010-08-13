 require 'rubygems'
# require 'minitest'
 require 'mini/test'


class TestExample < Mini::Test::TestCase

attr_accessor :subject

def initialize (name)
		@subject = 7

	super(name)
	end

def test_mod
	puts "subject:#{subject}"
	assert_equal 7 % subject, 0
	assert_equal 10 % subject, 3
	assert_equal 7,subject	
end



end


