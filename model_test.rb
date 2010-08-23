#require 'tests/test_adapt_test'
require 'adaptable_test'
#require 'model'
require 'dm-transactions'

class ModelTest < AdaptableTest


	
  def setup
    repository(:default) do
  #  	puts '###################'
 #   	puts self.object_id
      transaction = DataMapper::Transaction.new(repository)
      transaction.begin
      repository.adapter.push_transaction(transaction)
#		puts transaction.inspect
    end
  end
  
  def teardown
    	#puts self.object_id
    repository(:default).adapter.pop_transaction.rollback
    #transaction.rollback
  end

end
