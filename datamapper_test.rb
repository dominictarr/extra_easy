require 'rubygems'
require 'dm-core'
#require 'dm-mysql-adapter'

  # A MySQL connection:
  DataMapper.setup(:default, 'mysql://root:mysql@localhost/dm_test')
  
  class RbFile
		include DataMapper::Resource

		property :id,         Serial   # An auto-increment integer key
		property :name,      String   # A varchar type string, for short strings
		property :code,       Text     # A text block, for longer string data.
		property :created_at, DateTime # A DateTime, for any date you might like.

#		belongs_to :class_symbol, :required => false

		has n, :klasss, :through => Resource

	end

	class Klass
		include DataMapper::Resource

		property :id,		Serial
		property :name,	String

		has n,:rb_file, :through => Resource
		
#		has n,:test_run, :through => Resource, :required => false
	end

#	class UnitTest
#		include DataMapper::Resource
#		property :id,		Serial
#		property :name,	String
		#property :klass, ClassSymbol
		#has n, :test_run, :required => false
#		has 1, :klass, :required => false
#	end
#	class TestRun
#		include DataMapper::Resource
#		property :id,		Serial
#		property :pass,	Boolean			
#		has n, :class_symbol #test subject
#		belongs_to :unit_test			
#	end

DataMapper.finalize

require  'dm-migrations'
DataMapper.auto_migrate!	

RbFile.create(
  :name      => "hello.rb",
  :code       => "puts \"hello, world!\"",
  :created_at => Time.now
)
t = RbFile.create(
  :name      => "test.rb",
  :code       => "true",
  :created_at => Time.now
)

cs = Klass.create(
	:name => :Test,
	:rb_file => [t]
)

r = RbFile.get(1)
r.code
puts r.inspect
cs = Klass.get(1)
puts cs.inspect
puts cs.rb_file.inspect


