require 'yaml'
require 'quick_attr'
 require 'rubygems'
# require 'open4'
# require 'modules/stdout_catcher'
require 'sandbox'

def include_header (code)
	eval code
end

class Tester 
	extend QuickAttr	
	quick_attr :test,:klass
	quick_array :requires
	quick_array :headers

	def run()
		requires.each {|r| 
			require r
		}
		headers.each {|r| 
			include_header r
		}
		t = include_header test.to_s
		k = include_header klass.to_s
		r = true
		t.test_methods.each{|m|
			r = false unless t.new(m).adapt(k) == "."
		}
		{:result => r}
		
	end
	
	def yaml_instruction (yaml)
		map = YAML::load(yaml)
		test map[:test]
		klass map[:klass]
		requires *map[:require] if map[:require]
		headers *map[:headers] if map[:headers]
		self
	end
	
	def run_sandboxed 
	
		sb = Sandbox.new
		sb.code ""
		requires.each{|r|
			sb.code << "require \"#{r}\"\n"
		}
		headers.each{|r|
			sb.code << "#{r}\n"
		}
		sb.code << "
		r = true
		#{test}.test_methods.each{|m|
			r = false unless #{test}.new(m).adapt(#{klass}) == \".\"
		}
		r
		"
		#puts sb.code
		{:result => sb.run}

	end
end
