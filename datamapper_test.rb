require 'rubygems'
require 'dm-core'
require 'model'

  # A MySQL connection:

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
cs = Klass.create(
	:name => :Test2,
	:rb_file => [t]
)

r = RbFile.get(1)
r.code
puts r.inspect
cs = Klass.get(1)
puts cs.inspect
puts cs.rb_file.inspect

Klass.all.each{|k|
	puts k.inspect
	puts "	#{k.rb_file.inspect}"
}

puts t.klasses.inspect
