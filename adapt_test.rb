require 'mini/test'

module AdapterForTest

	class MiniRunner
		def puke (*args)
			puts args.join(" ")
			return 			[args[0].to_s,args[1],args[2]]

		end
	end
	
	def subject 
		@subject ||= default_subject
	end

	def subject= sub
		@subject = sub
		@subject
	end
	
	def default_subject
		raise "must redefine 'default_subject'"
	end
	
	def adapt(*sub)
		raise "Adaptable must extend a Mini::Test::TestCase" unless self.is_a? Mini::Test::TestCase
			
			@subject = (sub.empty? ? default_subject : sub.first)
			r = run MiniRunner.new
			return r
	end
end

class AdaptTest

def adapt(test,subject)
	def puke (*args)
		puts args.join(" ")
		return args
	end
	
	test.test_methods.each{|m|
		t = test.new(m)
		t.subject = subject
		r = t.run self	
		return r unless r.nil?
	}
	true
end
end
