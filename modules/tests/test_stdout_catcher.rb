require 'test/unit'
require 'modules/stdout_catcher'
class TestStdoutCatcher < Test::Unit::TestCase 

#include StdoutCatcher	
	def test_simple
		
		h = StdoutCatcher.catch_out {
			puts "Hello"
		}
		puts "done"
		assert_equal "Hello\n",h
		h = StdoutCatcher.catch_out {
			puts "goodbye"
		}
		puts "done"
		assert_equal "goodbye\n",h
	end
end
