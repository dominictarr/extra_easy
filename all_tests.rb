#load all tests
require 'rubygems'
require 'test/unit'
require 'mini/test'
include Test::Unit


def run_all_tests
		tests = `ls -1 */test*.rb`
	#puts tests
		tests = tests.split("\n").select{|it|
			#puts it 
			it =~ /^.*\/test_.*\.rb$/
			}
	tests.inspect
	#tests = tests - ["class_herd/test_rewire2.rb","class_herd/test_interface.rb"]
	tests.each{|test|
		Mini::Test.autorun
		puts "@@@@@@@@@@@@@@@@@@@@"
		puts test
		puts "@@@@@@@@@@@@@@@@@@@@"
				
		require test
		}
		
end

if __FILE__ == $0 then

	run_all_tests
end
