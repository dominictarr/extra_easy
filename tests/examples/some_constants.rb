#require 'class_herd/examples/module_with_constants'
class SomeConstants
#include DifferentModule::ModuleWithConstants
AConstant = "const_value"
PI = 3.14159
def const_value
	return String.new(AConstant)
end
def undefined
               defined?(PP)
       end
#def from_include
#	puts "#{SqrtTen}"
#	DoNothing.new
#end
       
end