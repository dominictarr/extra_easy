
class TestAdaptableTest < AdaptableTest

def default_subject; TestAdaptTest; end

def test_is_adaptable
	m = subject.test_methods
	m.each{
		n = 
		assert_equal ".",subject.new(m).adapt[:result]
		assert_equal "E", subject.new(m).adapt(nil)[:result]
	}
	assert m.length > 0	
end

end
