require 'test/unit'
require 'rb_parser'

module ClassHerd 
class TestRbParser < Test::Unit::TestCase
	#this is an implementation test, 
	#not an interface test.
	EXAMPLE_PATH = "./tests"
	def test_handle_class_name
		p = RbParser.new(nil)
		assert_equal :Object, p.handle_class_name(nil)
		assert_equal :Object, p.handle_class_name(:Object)
		modclass = s(:colon2, s(:const, :Module), :Class)
		assert_equal :"Module::Class", 
				p.handle_class_name(modclass)
	end
	def test_process_module
		sexp = s(:module, :Module2, 
				s(:scope, 
					s(:class, :Class2, nil, s(:scope))
				))
		sexp2 = s(:module, :Module2, 
				s(:scope, 
					s(:class, :Class2, :Object, s(:scope))
				))
		p = RbParser.new(nil)
		assert_equal sexp2,p.process_module(sexp)
		assert_equal [:Module2,:"Module2::Class2"],p.classes
	end
	def test_process_class
		sexp = s(:class, :EmptyClass, nil, s(:scope))
		sexp2 = s(:class, :EmptyClass, :Object, s(:scope))
		p = RbParser.new(nil)
		assert_equal sexp2,p.process_class(sexp)
		#assert_equal [:EmptyClass], p.classes
		sexp = s(:class,
				:TestRbParser,
				s(:colon2, s(:colon2, s(:const, :Test), :Unit), :TestCase),
				s(:scope))

		sexp2 = s(:class,
				:TestRbParser,
				:"Test::Unit::TestCase",
				s(:scope))

		p = RbParser.new(nil)
		assert_equal sexp2,p.process_class(sexp)
		assert_equal [:TestRbParser], p.classes
	end
	def test_examples
		p = RbParser.new(EXAMPLE_PATH + "/examples/empty_class.rb")

		p.parse
		assert_equal [:EmptyClass], p.classes
		p = RbParser.new(EXAMPLE_PATH + "/examples/outer_class.rb")
		p.parse
		assert_equal [:OuterClass,:"OuterClass::InnerClass"], p.classes
		p = RbParser.new(EXAMPLE_PATH + "/examples/example_modules.rb")
		p.parse
		assert_equal [:Module1,
			:"Module1::Class1",
			:"Module1::Module2",
			:"Module1::Module2::Class2"], p.classes
	end	
end;end
