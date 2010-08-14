	require 'rubygems'
	require 'sinatra'
require 'depends'
require 'tester'
require 'yaml'
	$d = Depends.new
	
	$d.depends_on(:TestAdaptableTest,"tests/test_adaptable_test.rb")
	#$d.depends_on(:TestPrimes,"modules/tests/test_primes.rb")
	#$d.depends_on(:Primes,"modules/primes.rb")
	#$d.depends_on(:SmartPrimes,"modules/smart_primes.rb")
	#$d.depends_on(:TooCleverPrimes,"modules/too_clever_primes.rb")
		
	##find tests
	tests = []
	subjects = []

	$test_subs = {}	

	def test_sub(test,sub)
		r =  Tester.new.
				test(test).
				klass(sub).
				requires(*($d.depends[test].to_a + $d.depends[sub].to_a)).
				run_sandboxed
				
		if r[:result] then
			$test_subs[test] ||= []
			$test_subs[test] << sub unless $test_subs[test].include? sub
		end
		r
	end
	
	$d.depends.each_key{|d|
		returned = test_sub(:TestAdaptableTest,d)
		puts returned[:result]

		if returned[:result]
			tests << d 
		else
			subjects << d
		end
	}
	
	puts "TESTs {"
	puts "\t#{tests.join(", ")}"
	puts "}"

	##step through tests and subjects and test everything.
	
	tests.each{|test|
		puts "test: #{test}"
		$d.depends.each_key{|sub|
			r = test_sub(test,sub)
			if r[:result] then
				puts "	-- #{sub}"
			end
		}
	}
	puts $test_subs.inspect
	def depends
		$d.depends
	end
	def test_subs
	
	puts $test_subs.inspect
		$test_subs
	end
	post '/submit' do
		content_type 'text/plain'
		#params.inspect + " " +  params['rb_file'].class.to_s
		puts params.inspect
		params['rb_file'][:tempfile].read
		#write while into a safe directory somewhere.
		f = File.new("./modules/" + params['rb_file'][:filename],'w')
		f.write(params['rb_file'][:tempfile].read)

		depends[params['class_name']] ||= []
		depends[params['class_name']] << f.path
		
		#now run tests!
		#check if it was a test,
		#test everthing if it was,
		#and run it against all tests.
	end
	get '/upload' do
		%{
			<form action="./submit" enctype="multipart/form-data" method="post" >
			ruby class:
			<input type=text name="class_name">
			ruby file:
			<input type=file name="rb_file">
			<input type=submit  value="Send">
			</form>			
		}
	end

	get '/' do
		s = ""
		if params["couple"] then
			content_type 'text/plain'
			klass = test_subs[params["couple"].to_sym].to_a.first
			a = [klass.to_s]
			depends[klass.to_sym].each{|r|
				 a << File.open(r).read
			}
			s << a.to_yaml
		else
		s = "<ol>"
		test_subs.each{|k,v|
			s << "  <li>"
			s << "  <a href=\"./?couple=#{k}\">#{k}</a><br>\n"
			s << "  <ol><li>#{v.join("</li><li>")}</li></ol>\n"
			s << "  </li>"
		}
		s << "</ol>"
		end
		s
		#$test_subs
	end
