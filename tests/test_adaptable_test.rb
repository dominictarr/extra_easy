
require 'tests/test_adapt_test'
require 'adaptable_test'
require 'tester'

class TestAdaptableTest < AdaptableTest

	def default_subject; TestAdaptTest; end

	def test_is_adaptable
		m = subject.test_methods
		puts "test_is_adaptable(#{subject})"
		nonsense = "NONSENSE_4357349t9hsdih8239rhyiuasrialsu324vq7wg6erft2f452"
	
		m.each{|n|
			_nil = subject.new(n).adapt(nonsense)
			assert_equal Tester::ERROR, _nil[:result], "expected fail message when #{subject}.adapt(\"#{nonsense}\")"
			assert _nil != Tester::PASS
		}
		assert m.length > 0	
	end
	def test_default
		m = subject.test_methods
		puts "test_is_adaptable(#{subject})"
	
		m.each{|n|
			test = subject.new(n)
			if test.respond_to? :default_subject and test.default_subject then #default subject can be nil.
				_default = test.adapt
				assert_equal Tester::PASS,_default[:result], "expected default class to pass"
			end
		}
		assert m.length > 0	
	end

end


if __FILE__ == $0 then
	puts "run TestAdaptableTest on itself!"
	TestAdaptableTest.new("test_is_adaptable").adapt(TestAdaptableTest)
end

