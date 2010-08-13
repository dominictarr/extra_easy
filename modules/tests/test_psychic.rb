require 'test/unit'
require 'psychic/psychic'

class TestPsychic < Test::Unit::TestCase
include Test::Unit
	#Psychic can make observe any object. 
	#it's powers from from metaprogramming the subject, 
	#aliasing mutable methods with methods which call's a closure
	#and then calling the old method.

	def test_simple
		called = false
		Psychic.connect(h = "Hello", :length) {|obj,method,value,*args|
			assert_equal h,obj
			assert_equal :length,method
			assert_equal 5,value
			assert_equal [],args #also test on something wit args
			called = true
		}
		assert_equal 5,h.length
		assert called, "expected psychic connection on \"#{h}\".length"
	end

	def test_with_args
		called = 0
		deleted = []
		Psychic.connect(h = [:a,:b,:c], :delete) {|obj,method,value,*args,&block|
			assert_equal h,obj
			assert_equal :delete,method
			assert  Symbol === value
			assert_equal [value] ,args
			deleted << value
			called = called + 1
		}
		h.delete :a
		h.delete :b
		h.delete :c

		assert_equal 3,called
		assert_equal deleted,[:a,:b,:c]
	end 

	def test_multiple_connections

		b_delete = b_called = called = 0
		deleted = []
		
		Psychic.connect(h = [:a,:b,:c], :delete) {|obj,method,value,*args|
			assert_equal h,obj
			assert_equal :delete,method
			assert  Symbol === value
			assert_equal [value] ,args
			deleted << value
			called = called + 1
		}
		Psychic.connect(h,:"<<", :delete) {|obj,method,value,*args|
			assert_equal h,obj
			b_called = b_called + 1
			if method == :delete then
				b_delete = b_delete + 1
			end
		}
		h.delete :a
		h.delete :b
		h.delete :c
		h << :d
		h << :e
		h << :f

		assert_equal 3,called
		assert_equal 6,b_called
		assert_equal 3,called
		assert_equal deleted,[:a,:b,:c]
	end

	def test_disconnect
		h = "Hello"
		called = false
		p = proc {|obj,method,value,*args,&block|
			assert_equal h,obj
			assert_equal :length,method
			assert_equal 5,value
			assert_equal [],args #also test on something wit args
			called = true
		}
		Psychic.connect(h, :length,&p)

		assert_equal 5,h.length
		assert called, "expected psychic connection on \"#{h}\".length"
		Psychic.disconnect(h,:length,&p)
		called = false
		assert_equal 5,h.length
		assert !called, "expected psychic connection disconnected on \"#{h}\".length"
		
	end


	def expect (state,code)
		assert state, "closure was not called for opperation: \"#{code}\""
		false
	end	

	def test_mutable(klass,code)#checks that result actually changes, and the block is called.
		before = nil		
		a = klass.new
		c = false
		Psychic.connect_mutable(a) {|object,method,value,*args,&block|
			puts "#{before.inspect}.#{method}(#{args.join(',')}) => #{object.inspect}"
			c = true
		}
		b = binding
		code.split("\n").each{|s| 
			before = a.dup
			eval(s,b); 
			c = expect(c,s)
			assert a != before, "expected opperation: #{s} to alter #{a.inspect} from #{before.inspect}"
		}

	end

	def test_array
	code = "a << :a
		a.delete :a
		a << :a
		a << :b
		a << :c
		a.reverse!
		a.reverse!
		a[1] = 2
		a[2] = 0
		a << [1,2,3]
		a << nil
		a.compact!
		a.flatten!
		a.slice!(1,4)
		a << a.dup
		a.flatten!
		a.map! {|x| x.to_s + '!'}
		a.uniq!"
		test_mutable(Array,code)	
	end

	def test_hash
		test_mutable(Hash,"a[1] = 123
		a[2] = 1231
		a[3] = 325235
		a.reject! {|k,v| v > 2000}
		a.merge! ({:a => :b})")	
	end

	def test_string
		test_mutable(String,"a << 'hello'
		a.capitalize!
		a.upcase!
		a.downcase!
		a['e'] = 'XXX'
		a << 'XXX'
		a.gsub!(/X/,'_')
		a.chomp!('_')")	
		#what about genetic algorithm to figure out test for when a function will change a state?
		#example, [:a].delete :a will change state, because [:a].include? :a
		# << will always change the state
		#also, we can discover what will produce errors.
		#or inductively prove that a method can't make errors.
		#it it's found an error, find most concise test which predicts error.
	end

end
