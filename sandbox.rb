require 'rubygems'
require 'open4'
require 'quick_attr'
require 'stdout_catcher'
require 'sandbox'

#what happens if you are running a sandbox, but you give it something with a syntax error?

class Sandbox 
extend QuickAttr
quick_attr :code,:output,:returned,:error
def run
	
	  Open4::popen4("ruby #{__FILE__}") do |pid, stdin, stdout, stderr|

			#puts code
			stdin.puts code
      	stdin.close
      	yaml = stdout.read.strip
      	#puts "YAML: <#{yaml}>"
      	report = YAML::load(yaml) || {} #need to catch puts, because the test prints a message if the test fails.
 			output report[:output]
 			returned report[:returned]
 			error report[:error]
			
 			err = stderr.read
			raise(err) if (err != "" )
		#	raise(report[:error] ... ) if report[:error]

			raise(" error running sandbox:
			#{report[:error]}... #{report[:error_trace].join("\n")}
			
CODE:========================================
#{code}			
=============================================
			") if report[:error]

		end
		returned

#	output StdoutCatcher.catch_out{
#		returned eval(code)
#	}
#	returned
end

end

	if __FILE__ == $0 then
		returned = nil

		error = nil
		output = StdoutCatcher.catch_out {
		code = $stdin.read
			begin
				returned = eval(code)
			rescue Exception => e
				error = e
			end
		}
		
		puts ({:returned => returned,:output => output, :error => error, :error_trace => (error ? error.backtrace : nil) }.to_yaml)
		puts "end".to_yaml #there is a problem with returning null, stdout seems to drop the last new line, so need something acceptable after.
	end

