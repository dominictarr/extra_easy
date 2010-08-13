	require 'rubygems'
	require 'sinatra'
require 'depends'
require 'tester'
require 'yaml'
	$d = Depends.new
	
	$d.depends_on(:TestAdaptableTest,"tests/test_adaptable_test.rb")
	$d.depends_on(:TestPrimes,"modules/tests/test_primes.rb")
	$d.depends_on(:Primes,"modules/primes.rb")
	$d.depends_on(:SmartPrimes,"modules/smart_primes.rb")
	$d.depends_on(:TooCleverPrimes,"modules/too_clever_primes.rb")
		
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
	get '/' do
		s = ""
		if params["test"] then
			content_type 'text/plain'
			klass = test_subs[params["test"].to_sym].to_a.first
			a = [klass]
			depends[klass.to_sym].each{|r|
				 a << File.open(r).read
			}
			s << a.to_yaml
		else
		s = "<ol>"
		test_subs.each{|k,v|
			s << "  <li>"
			s << "  <a href=\"./?test=#{k}\">#{k}</a><br>\n"
			s << "  <ol><li>#{v.join("</li><li>")}</li></ol>\n"
			s << "  </li>"
		}
		s << "</ol>"
		end
		s
		#$test_subs
	end
