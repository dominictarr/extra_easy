
require 'tests/test_adapt_test'
require 'adaptable_test'

class TestAdaptableTest < AdaptableTest

def default_subject; TestAdaptTest; end

def test_is_adaptable
	m = subject.test_methods
	puts "test_is_adaptable(#{subject})"
	nonsense = "NONSENSE_4357349t9hsdih8239rhyiuasrialsu324vq7wg6erft2f452"
	m.each{|n|
		_default = subject.new(n).adapt
		_nil = subject.new(n).adapt("NONSENSE")
		puts "	#{n} -> (default: #{_default.inspect}  random: #{_nil.inspect})"
		assert_equal ".",_default[:result]
		puts _nil.inspect
		assert_equal "E", _nil[:result], "expected fail message when #{subject}.adapt(\"#{nonsense}\")"
		assert _nil != "."
	}
	assert m.length > 0	
end
end


if __FILE__ == $0 then

puts "run TestAdaptableTest on itself!"
TestAdaptableTest.new("test_is_adaptable").adapt(TestAdaptableTest)


end

