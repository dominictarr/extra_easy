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
	PASS = "pass"
	FAIL = "Fail."
	ERROR = "ERROR!"

	extend QuickAttr	
	quick_attr :test,:klass
	quick_array :requires
	quick_array :headers
	
	def run()
		result = Hash.new
		require 'coupler'
		require 'adaptable_test'
		self.class.send(:include, Coupler)

		puts "+++++++++++++++++++++++++++++++"
		puts headers.inspect
		headers.each {|r| 
			include_header r
		}
		requires.each {|r| 
			require r
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
			r = false unless result[m][:result] == Tester::PASS  #here is checks for a pass.
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
		sb.code << "require 'rubygems'\n"
		sb.code << "require 'mini/test'\n"
		sb.code << "require 'tester'\n"
		sb.code << "require 'adaptable_test'\n"
		sb.code << "require 'coupler'\n"
		sb.code << "include Coupler\n"
		requires.each{|r|
			sb.code << "require \"#{r}\"\n"
		}
		sb.code << "module ASandBoxedTest\n" 
		headers.each{|r|
			sb.code << "#{r}\n"
		}
		sb.code << "def self.run_test_324923897498234723249;
		Tester.new.test(#{test}).klass(#{klass}).run; 
		end\n"
	
		sb.code << "end\n"
		sb.code << "ASandBoxedTest::run_test_324923897498234723249\n"

		sb.run

	end
end
