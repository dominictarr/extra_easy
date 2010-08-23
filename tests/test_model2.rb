require 'dm_test'
require 'model2'
require 'model_test'

class TestModel2 < ModelTest
	def default_subject; NilClass; end

	def test_klass
		test_x = Klass.create(:name => 'TestX')
		
		x = Klass.create(:name => 'X')

		assert test_x.saved?
		assert x.saved?

		tr = TestRun.create(:klass => x, :test => test_x, :pass => true)
		assert tr.saved?

		assert_equal [tr], test_x.this_test_runs
		assert_equal [tr], x.test_runs
		
		assert_equal [x], test_x.klasses_passed
		assert_equal [test_x], x.tests_passed

		y = Klass.create(:name => 'Y')
		test_y = Klass.create(:name => 'TestY')

		assert y.saved?
		tr2 = TestRun.create(:klass => y, :test => test_x, :pass => false)
		tr3 = TestRun.create(:klass => x, :test => test_y, :pass => true)
		assert tr2.saved?
		assert tr3.saved?
		
		assert_equal [tr2], y.test_runs
		assert [tr,tr2], TestRun.all(:test => test_x)
		assert [tr,tr3], TestRun.all(:klass => x)
		x.reload
		assert_equal TestRun.all(:klass => x), x.test_runs
		test_x.reload
		assert_equal [tr,tr2], test_x.this_test_runs

		puts TestRun.all.inspect
		assert_equal [test_x,test_y], x.tests_passed
		assert_equal [], y.tests_passed

		assert_equal [x], test_x.klasses_passed
	end
	
	def test_is_test
				tat = Klass.first(:name => :TestAdaptableTest)
				assert_equal true, tat.is_test
				assert tat.klasses_passed.include? tat	 
				tr = TestRun.first(:test => tat, :klass => tat)
				assert true, tr.pass
	end
	
	def test_run_tests
		tat = Klass.first(:name => :TestAdaptableTest)
		tp = Klass.create(:name => :TestPrimes, :rb_files => [RbFile.load_rb("modules/tests/test_primes.rb")])
		
		p = Klass.create(:name => :Primes, :rb_files => [RbFile.load_rb("modules/primes.rb")])
		sp = Klass.create(:name => :SmartPrimes, :rb_files => [RbFile.load_rb("modules/smart_primes.rb")])
		tp.run_all_tests
		p.run_all_tests
		sp.run_all_tests
		tat.reload
		
		assert tp.tests_passed.include? tat
		assert tat.klasses_passed.include? tp
		
		assert p.tests_passed.include? tp
		assert tp.klasses_passed.include? p
		assert tp.klasses_passed.include? sp		
	end
	
	def test_parse_from_rb_file
		klasses = []
		klasses += RbFile.load_rb("modules/tests/test_primes.rb").parse
		klasses += RbFile.load_rb("modules/primes.rb").parse
		klasses += RbFile.load_rb("modules/smart_primes.rb").parse
	
		tp = Klass.first(:name => :TestPrimes)
		p = Klass.first(:name => :Primes)
		sp = Klass.first(:name => :SmartPrimes)
		assert tp
		assert p
		assert sp

		assert_equal [p,sp], tp.klasses_passed
	end
	
	
	def test_auto_join
	
		t = Thing.create()
		w = Whatever.create()
		
		t.whatevers << w
		t.save
		assert_equal [t], w.things

		t2 = Thing.create()
		w2 = Whatever.create()
		
		ThingWhatever.create(:thing => t2, :whatever => w2)
		assert_equal [t2], w2.things
		assert_equal [w2], t2.whatevers
		ThingWhatever.create(:thing => t2, :whatever => (w3 = Whatever.create))
		t2.reload
		assert_equal [w2,w3], t2.whatevers
	end


end

Mini::Test.autorun
