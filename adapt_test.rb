require 'mini/test'
require 'minitest/unit'

module AdapterForTest
	class MiniRunner < Hash
		def puke klass,method,error

			self[:error] = error.class.name
			self[:message] = error.message
			
			self[:trace] = error.backtrace.join("\n")

			case error
				when Mini::Assertion then
					self[:result] = "Fail."
				else
					self[:result] = "ERROR!"
				end
			return 		self
		end
		def to_hash
			Hash.new.merge(self)
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
			self._assertions = 0
			@subject = (sub.empty? ? default_subject : sub.first)
			mr = MiniRunner.new
			r = run  mr
			#self[:klass] = klass.name
			mr[:method] = @name

			mr[:result]= "pass" if mr[:result].nil?

			return mr.to_hash
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
