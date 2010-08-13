
class TestAdaptableTest < AdaptableTest

def default_subject; TestAdaptTest; end

def test_is_adaptable
	m = subject.test_methods
	m.each{
		n = 
		assert_equal ".",subject.new(m).adapt
		assert subject.new(m).adapt(nil)
	}
	assert m.length > 0	
end

end
