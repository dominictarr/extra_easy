require 'test/unit'
require 'modules/sandbox'

class SandboxTester < Test::Unit::TestCase 

	def test_simple
		sb = Sandbox.new.code "print \"hello\"; true"
		sb.run
		#puts sb.output
		assert_equal "hello", sb.output
	
	end

	def test_constant
	
		sb = Sandbox.new.code "class NewConstant; end; nil"
		sb.run
		assert_equal "", sb.output
		assert_equal nil, sb.returned	
		begin
			eval "Sandbox::NewConstant"
			raise "expected NameError"
		rescue NameError => n
		end

		begin
			eval "NewConstant"
			raise "expected NameError"
		rescue NameError => n
		end
	
	end

	def test_error
		sb = Sandbox.new.code "raise \"an exception\""
		sb.run
		#puts sb.output
		assert_equal "", sb.output
		puts sb.error
		assert sb.error.is_a?(Exception)
		
	end

end


