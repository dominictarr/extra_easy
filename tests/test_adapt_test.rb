require 'adaptable_test'
require 'tests/examples/test_example3'

class TestAdaptTest < AdaptableTest
#module which sticks onto a regular unit test the ability to re assign the tested class

	def default_subject; AdapterForTest; end

	class MiniRunner
		def puke (*args)
			print "puke:"
			puts args.join(" ")
		end
	end

	def test_test_example3
		puts "ruby test"
		t = Class.new(TestExample3)


		t.send(:include,subject)
		t.send(:define_method,:default_subject){7}
		mr = MiniRunner.new

		test = t.new("test_mod")
		assert_equal ".",test.run(mr)
	
		assert test.adapt(6)
		assert_equal 6, test.subject
		assert_equal ".", test.adapt(7)
		assert_equal 7, test.subject
		assert  test.adapt(8)
		assert_equal 8, test.subject
	end	

end

Mini::Test.autorun

