

require 'model_test.rb'
require 'model2.rb'
require 'datetime_convert'

class TestRbFile < ModelTest

	def default_subject; RbFile; end

	def test_create
		t = subject.create( 
			:name => 'hello.rb',
			:code => 'puts "hello, world!"',
			:created_at => tn = Time.now.to_datetime
		)
		puts t.created_at.methods

		assert_equal tn, t.created_at, "expected times to be equal"

	end
	
	def test_load
		t = subject.load_rb('tests/db_test_rb_file.rb')
#		assert_equal 'tests/test_rb_file.rb',t.name
		assert_equal File.open('tests/db_test_rb_file.rb').read,t.code
#		puts t.code
	end
end
