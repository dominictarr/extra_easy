require 'rubygems'
require 'dm-validations'
require  'dm-migrations'
require 'tester'
require 'rb_parser'
  class RbFile
		include DataMapper::Resource

		property :id,         Serial   # An auto-increment integer key
		property :name,      String  # A varchar type string, for short strings
		property :code,       Text     # A text block, for longer string data.
		property :created_at, DateTime # A DateTime, for any date you might like.

		validates_uniqueness_of :name

		has n, :klasses, :through => Resource

		def parse
			r = ClassHerd::RbParser.new(code).parse
			puts "classes Parsed from #{name}"
			puts r.classes
			added = []
			r.classes.each{|e|
				k = Klass.first_or_create(:name => e)
				k.rb_files << self unless k.rb_files.include? self
				k.run_all_tests
				puts "UPDATED: #{k.name}"
				added << k
			}
			added
		end
		
		def self.load_rb(file)
			if file.is_a? String then
				file = File.open(file)
			end
			r = RbFile.first_or_create(
				{:name => file.path,},
				{:code => file.read, :created_at => Time.now}
			)
			
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
		property :pass,Boolean

		belongs_to :klass, :key => true
		belongs_to :test, 'Klass', :key => true

		def run
				r =  Tester.new.
				test(test.name).
				klass(klass.name).
				headers((test.code + klass.code)).
				run_sandboxed
				self.pass= r[:result]
				save
				reload
				r[:result]
		end

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

DataMapper.auto_migrate!	
DataMapper.finalize

rb = RbFile.load_rb('tests/test_adaptable_test.rb')
t = Klass.first_or_create(
		:name => 'TestAdaptableTest', 
		:is_test => true)
rb.klasses << t
rb.save
rb.reload
t.reload

tr = t.run_test(t) #runs this test on it self... returns a TestRun
tr.pass
puts tr.inspect
puts rb.parse

raise "expected TestAdaptableTest.run_test(TestAdaptableTest) to pass" unless tr.pass
	


	
