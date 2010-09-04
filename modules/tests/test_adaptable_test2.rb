require 'tests/test_adapt_test'
require 'adaptable_test'

class TestAdaptableTest2 < AdaptableTest

	def default_subject; TestAdaptableTest; end

	def test_has_subject
		m = subject.test_methods
	
		m.each{|n|
		      test = subject.new(n)
		      assert m = test.method(:adapt), "expected to have adapt() method"
	#          ##assert m.arity <= -1
		}
		assert m.length > 0	
	end

	def test_is_adaptable
		m = subject.test_methods
		puts "test_is_adaptable(#{subject})"
		nonsense = "NONSENSE_4357349t9hsdih8239rhyiuasrialsu324vq7wg6erft2f452"
	
		m.each{|n|
			_nil = subject.new(n).adapt(nonsense)
			assert_equal "ERROR!", _nil[:result], "expected fail message when #{subject}.adapt(\"#{nonsense}\")"
			assert _nil != "pass"
		}
		assert m.length > 0	
	end
end

