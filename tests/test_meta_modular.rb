
  require 'rubygems'
  require 'meta_modular'
  require 'rack/test'
  require 'test/unit'

  class TestSinatraHello < Test::Unit::TestCase
    include Rack::Test::Methods
	
    def app
      MetaModular
    end

    def test_my_default
      get '/'
      assert_equal 'Hello World!', last_response.body
    end

#    def test_with_params
 #     get '/meet', :name => 'Frank'
  #    assert_equal 'Hello Frank!', last_response.body
   # end

  end
