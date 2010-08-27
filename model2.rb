require 'rubygems'
require 'dm-validations'
require  'dm-migrations'
require 'tester'
require 'rb_parser'

  class RbFile
		include DataMapper::Resource

#		property :id,         Serial   # An auto-increment integer key
		property :name,      String, :key => true # A varchar type string, for short strings
		property :code,       Text     # A text block, for longer string data.
		property :created_at, DateTime # A DateTime, for any date you might like.

		validates_uniqueness_of :name

		has n, :klasses, :through => Resource

		def parse
			r = ClassHerd::RbParser.new(code).parse
			#puts "classes Parsed from #{name}"
			#puts r.classes
			added = []
			r.classes.each{|e|
				k = Klass.first_or_create(:name => e)
				k.rb_files << self unless k.rb_files.include? self
				k.run_all_tests
			#	puts "UPDATED: #{k.name}"
				added << k
			}
			added
		end
		
		def self.load_rb(file)
			if file.is_a? String then
				file = File.open(file)
			end
			r = RbFile.first_or_create(:name => file.path)
			r.code = file.read
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

		has n,:rb_files, :through => Resource
		has n, :test_runs
		has n, :this_test_runs, 'TestRun', :child_key => ['test_id']
		
		def run_test (subject)

			tr = TestRun.first_or_create(:klass => subject,:test => self)
			if tr.pass.nil? then
				tr.run
			end
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
			check_is_test
			Klass.all(:is_test => true).each{|e|
				e.run_test(self)
			}
		end

		def code 
			rb_files.collect{|f| f.code}.join("\n")
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

		def run
				
				r =  Tester.new.
					test(test.name).
					klass(klass.name).
					headers((test.code + klass.code)).
					run_sandboxed
				puts
				puts "TEST #{klass.name} ON #{test.name} ==> #{r[:pass]}"
				puts
 				self.pass= r[:pass]
				time = 0.0
				r.each {|k,v|
					if v.is_a? Hash then
					
						trm = TestRunMethod.first_or_create({
								:method_name => v[:method], 
								:test_run => self},
								{:error => v[:error],
								:message => v[:message],
								:trace => v[:trace],
								:result => v[:result],
								:time_taken => v[:time],
								:output => v[:output]}
						)
						
						case trm.result
							when "fail." then
								self.result = trm.result if self.result == "pass"
							when "ERROR!" then
								self.result = trm.result
							else
								self.result = "pass"
							end							
						time += trm.time_taken
						raise "NOT SAVED!!!! #{v.inspect}" unless trm.saved? 
					end
				}
				self.total_time = time
				puts
				puts "Test #{klass.name} on #{test.name} => #{pass} in #{total_time}"
				puts
 				
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
DataMapper.auto_migrate! if ARGV.include? "MIGRATE"

#if __FILE__ == $0 then
#	MetaModular.run! :host => 'localhost', :port => 5678
#end

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

#puts rb.parse

#raise "expected TestAdaptableTest.run_test(TestAdaptableTest) to pass" unless tr.pass
	


	

