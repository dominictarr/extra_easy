 require 'rubygems'
# require 'minitest'
 require 'mini/test'
 require 'adapt_test'


class TestExample3 < Mini::Test::TestCase

#	include AdapterForTest

	def subject; 7 ; end
	def default_subject; 7; end

	def test_mod
#		puts "subject:#{subject.inspect} -- #{self.class}"
		assert_equal 7 % subject, 0
		assert_equal 10 % subject, 3
		assert_equal 7,subject
	end
end


