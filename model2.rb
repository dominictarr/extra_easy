require 'rubygems'
require 'dm-validations'
require  'dm-migrations'
require 'tester'
require 'rb_parser'
require 'adapt_test'

  class RbFile
		include DataMapper::Resource

		property :id,      	Serial
		property :name, 		String # a hash of the code
		property :code_hash, Integer # a hash of the code
		property :code,      Text	     # A text block, for longer string data.
		property :created_at,DateTime # A DateTime, for any date you might like.

		validates_uniqueness_of :name
		validates_uniqueness_of :code_hash

		has n, :klasses
		def parse
			r = ClassHerd::RbParser.new(code).parse
			#puts "classes Parsed from #{name}"
			#puts r.classes
			added = []
			r.classes.each{|e|
				#make an error if the class is already defined in a different file?
				k = Klass.first_or_create(:name => e)
				k.rb_file = self
				k.save
				k.run_all_tests

				added << k
			}
			added
		end
		def self.load_code(code,name="ruby_#{code.hash.to_s(36)}")
			rb = RbFile.new
			rb.name = name
			rb.code = code
			rb.code_hash = code.hash
			rb
		end		
		def self.load_rb(file)
			if file.is_a? String then
				file = File.open(file)
			end
			code = file.read
			r = RbFile.first_or_create(:code => code, :code_hash => code.hash, :name => "ruby_#{code.hash}")
			
			r.save
			file.close
			r
		end

	end

	class Klass
		include DataMapper::Resource
		property :id,		Serial
		property :name,	String
		property :is_test,Boolean

		validates_uniqueness_of :name
		validates_presence_of	:name

		belongs_to :rb_file
		has n, :test_runs
		has n, :this_test_runs, 'TestRun', :child_key => ['test_id']
		
		def run_test (subject)
			puts "#{self.name}.run_test(#{subject.name})"
			tr = TestRun.first_or_create(:klass => subject,:test => self)
#			if tr.pass.nil? then
			tr.run
#			end
			tr.save
			return tr
		end

		def check_is_test
			if Klass.first(:name => :TestAdaptableTest).run_test(self).pass then
				self.is_test = true
				self.save
				return true
				
			end
			false
		end

		def run_all_tests
			if check_is_test then
			Klass.all.each{|e|
				self.run_test(e)
			}				
			end
			Klass.all(:is_test => true).each{|e|
				e.run_test(self)
			}
		end

		def code 
			rb_file.code
		end

		def tests_passed
			Klass.all(:this_test_runs => {:klass => self, :pass => true})
		end
		def klasses_passed
			Klass.all(:test_runs => {:test => self, :pass => true})
		end
	end
	
	class TestRun
		include DataMapper::Resource

		belongs_to :klass, :key => true
		belongs_to :test, 'Klass', :key => true
		has n,:test_run_methods
		
		property :total_time, Float
		property :pass,	Boolean
		property :result,	String
		property :last_run,	DateTime

		def run
			r =  Tester.new.
				test(test.name).
				klass(klass.name).
				headers((test.code + klass.code)).
				run_sandboxed
				
			raise "got no results from test:#{test.name} -> class:#{klass.name}" unless r
			
			self.pass= r[:pass]
			time = 0.0
			self.result = Tester::PASS
			self.last_run = Time.now
			self.save
			raise "#{self.inspect} NOT SAVED!!!" unless self.saved?

			puts "Test #{klass.name} on #{test.name} => #{pass} in #{total_time}"

			message = nil
			error = nil

			r.each {|k,v|
				if v.is_a? Hash then
				
					trm = TestRunMethod.first_or_create(
							:method_name => v[:method], 
							:test_run => self)
					trm.error = v[:error]
					trm.message = v[:message]
					trm.trace = v[:trace]
					trm.result = v[:result]
					trm.time_taken = v[:time_taken] || 0
					trm.output = v[:output]
					trm.save
					
					case trm.result
						when Tester::FAIL then
							puts message = "		Fail! #{trm.message}" unless message
							self.result = trm.result if self.result == Tester::PASS
						when Tester::ERROR then
							puts message = "		#{error = trm.error} #{trm.message}" unless error
							self.result = trm.result
						else
							self.result = Tester::PASS
						end							
					time += trm.time_taken
					unless trm.saved? then
						raise "#{trm.inspect} NOT SAVED!!!!  #{v[:method]}"
					end
				end
			}
			self.total_time = time
			
			save
			reload
			r[:pass]
		end

	end

	class TestRunMethod
	  include DataMapper::Resource
		belongs_to :test_run, :key => true
		property :method_name, String, :key => true
		property :result, String
		property :error, String
		property :message, Text
		property :output, Text
		property :trace, Text
		property :time_taken, Float
	end
	
class Whatever
  include DataMapper::Resource
  property :id,   Serial
	has n, :things, :through => Resource
end

class Thing
  include DataMapper::Resource
  property :id,   Serial
	has n, :whatevers, :through => Resource
end


DataMapper.finalize

def initialize_database 
	rb = RbFile.load_rb('tests/test_adaptable_test.rb')
	t = Klass.first_or_create(
			:name => 'TestAdaptableTest', 
			:is_test => true)
	
	rb.klasses << t
	rb.save
	rb.reload
	t.reload

	tr = t.run_test(t) #runs this test on it self... returns a TestRun
	puts tr.pass
	puts tr.inspect
	puts tr.test_run_methods.inspect
end
	
if ARGV.include? "MIGRATE" then
	DataMapper.auto_migrate! 
	initialize_database
end

