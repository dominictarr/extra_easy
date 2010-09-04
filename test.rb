require 'rubygems'
require 'mini/test'
require 'tester'
require 'adaptable_test'
require "tests/test_adaptable_test"
module ASandBoxedTest

		class TestSimple < AdaptableTest
			def default_subject; nil; end 
			def test_initialize
				assert subject.new, "Tester should have .new method"
				assert_equal subject, subject.new.class, "Tester.new.class returns Tester"
			end
		end
		#class DefaultSubject; end
		
def self.run_test_324923897498234723249;
		Tester.new.test(TestSimple).klass(TestAdaptableTest).run; 
		end
end
ASandBoxedTest::run_test_324923897498234723249

