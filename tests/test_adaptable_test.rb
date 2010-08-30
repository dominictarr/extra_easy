
require 'tests/test_adapt_test'
require 'adaptable_test'

class TestAdaptableTest < AdaptableTest

def default_subject; TestAdaptTest; end

def test_is_adaptable
	m = subject.test_methods
	puts "test_is_adaptable(#{subject})"
	nonsense = "NONSENSE_4357349t9hsdih8239rhyiuasrialsu324vq7wg6erft2f452"
	
	m.each{|n|
		_nil = subject.new(n).adapt("NONSENSE")
		assert_equal "ERROR!", _nil[:result], "expected fail message when #{subject}.adapt(\"#{nonsense}\")"
		assert _nil != "pass"
	}
	assert m.length > 0	
end
def test_default
	m = subject.test_methods
	puts "test_is_adaptable(#{subject})"
	
	m.each{|n|
		_default = subject.new(n).adapt
		assert_equal "pass",_default[:result], "expected default class to pass"
		assert _nil != "pass"
	}
	assert m.length > 0	
end

end


if __FILE__ == $0 then

puts "run TestAdaptableTest on itself!"
TestAdaptableTest.new("test_is_adaptable").adapt(TestAdaptableTest)


end

