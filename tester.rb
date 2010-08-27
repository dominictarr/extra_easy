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
		result = Hash.new
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
			#take time
			#capture output
			returned = {}
			o = StdoutCatcher.catch_out{
				start = Time.now
				returned = t.new(m).adapt(k)
				diff = Time.now - start
				returned[:time] = diff
			}
			returned[:output] = o
			result[m] = returned
			r = false unless result[m][:result] == "pass"  #here is checks for a pass.
		}
		result[:pass] = r
		result
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
		sb.code << "require 'rubygems'\n"
		sb.code << "require 'mini/test'\n"
		sb.code << "require 'tester'\n"
		headers.each{|r|
			sb.code << "#{r}\n"
		}
#		sb.code << "
#		result = {:pass => true}\n" + 
		#~ #{test}.test_methods.each{|m|
		#~ 	r = false unless #{test}.new(m).adapt(#{klass}) == \".\"
#		"#{test}.test_methods.each{|m|
#			result[m] = #{test}.new(m).adapt(#{klass})
#			result[:pass] = false unless result[m][:result] == \".\"  #here is checks for a pass.
#		}
#		result
#		"
		sb.code << "Tester.new.test(#{test}).klass(#{klass}).run"
		#puts sb.code
		sb.run

	end
end
