#sql
require 'rubygems'
require 'dm-transactions'
require 'dm-migrations'
require 'dm-core'

  DataMapper.setup(:default, 'mysql://root:mysql@localhost/dm_test')

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

      transaction = DataMapper::Transaction.new(repository(:default))
      transaction.begin
      repository(:default).adapter.push_transaction(transaction)
		
		t = Thing.create()
		w = Whatever.create()
		
		ThingWhatever.create(:thing => t, :whatever => w)
		puts "[t] == w.things => #{[t] == w.things}"
		puts "[w] == t.whatevers => #{[w] == t.whatevers}"
		ThingWhatever.create(:thing => t, :whatever => (w2 = Whatever.create))
		puts "[w,w2] == t.whatevers => #{[w,w2] == t.whatevers}"

 
    repository(:default).adapter.pop_transaction.rollback


