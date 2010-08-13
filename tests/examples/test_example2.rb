 require 'rubygems'
# require 'minitest'
 require 'mini/test'
 require 'adapt_test'


class TestExample2 < Mini::Test::TestCase

	include AdapterForTest

	def default_subject; 7; end

	def test_mod
		puts "subject:#{subject.inspect}"
		assert_equal 7 % subject, 0
		assert_equal 10 % subject, 3
		assert_equal 7,subject	
	end
end


