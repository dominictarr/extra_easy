require 'rubygems'
require 'dm-core'
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root:mysql@localhost/dm_prod')
#  DataMapper.setup(:default, 'mysql://root:mysql@localhost/dm_prod')

