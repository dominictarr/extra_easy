
require 'tests/test_adapt_test'
require 'adaptable_test'

class TestAdaptableTest < AdaptableTest

def default_subject; TestAdaptTest; end

def test_is_adaptable
	m = subject.test_methods
	puts "test_is_adaptable(#{subject})"
	m.each{|n|
		_default = subject.new(n).adapt
		_nil = subject.new(n).adapt("NONSENSE")
		puts "	#{n} -> (#{_default}/#{_nil.inspect})"
		assert_equal ".",_default
		assert _nil.is_a?(Array), "expected fail message when #{subject}.adapt(\"NONSENSE_4357349t9hsdih8239rhyiuasrialsu324vq7wg6erft2f452\")"
		assert _nil != "."
		 
	}
	assert m.length > 0	
end
end


#if __FILE__ == $0 then

#puts "run TestAdaptableTest on itself!"
#TestAdaptableTest.new("test_is_adaptable").adapt(TestAdaptableTest)


#end

