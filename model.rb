require 'rubygems'
#require 'dm-mysql-adapter'

  # A MySQL connection:
  
  class RbFile
		include DataMapper::Resource

	#	property :id,         Serial   # An auto-increment integer key
		property :name,      String, :key => true  # A varchar type string, for short strings
		property :code,       Text     # A text block, for longer string data.
		property :created_at, DateTime # A DateTime, for any date you might like.

#		belongs_to :class_symbol, :required => false

		has n, :klasses, :through => Resource
		
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

#		property :id,		Serial
		property :name,	String, :key => true

		has n,:rb_files, :through => Resource
		
#		has n,:test_run, :through => Resource, :required => false
		#has n, :test_runs, :required => false
		
		has 1, :unit_test
	end

	class UnitTest
		include DataMapper::Resource
		property :id,		Serial
		#property :klass, ClassSymbol
		property :name, String
		
		has n, :test_runs#, :required => false
		belongs_to :klass
	end
	
	class TestRun
		include DataMapper::Resource
#		property :id,		Serial
		property :pass,	Boolean
		
		property :error,      String
#		property :output,       Text
#		property :trace,       Text
					
		belongs_to :klass , :key => true
		belongs_to :unit_test , :key => true
	end

require  'dm-migrations'
DataMapper.auto_migrate!	
DataMapper.finalize




