
require 'tests/model_test'
require 'models.rb'

class RbFileTest < ModelTest

	def default_subject; RbFile; end

	def test_create
		t = subject.create( 
			:name => 'hello.rb',
			:code => 'puts "hello, world!"',
			:created_at => Time.now
		)
		
		assert t.new_record
		
	end
end
