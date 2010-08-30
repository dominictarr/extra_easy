require 'rubygems'
require 'sinatra/base'
require 'dm_prod'
require 'model2'
require 'html_dsl'
require 'modules/stdout_catcher'
require 'rb_parser'
require 'adaptable_test'

class MetaModular < Sinatra::Base
	include HtmlDsl
	def initialize(app=nil)
		super(app)
	end

	post '/submit' do
		rb = RbFile.load_rb(params['rb_file'][:tempfile])

		k = rb.parse
		"loaded #{k.map{|m| m.name}.join(",")}, redirecting..."
		redirect "/klass/#{k.first.name}"
	end
	get '/upload' do
		%{
			<form action="/submit" enctype="multipart/form-data" method="post" >
			ruby file:
			<input type=file name="rb_file">
			<input type=submit  value="Send">
			</form>			
		}
	end
	get '/rb_file/:file_name' do
		content_type 'text/plain'
		RbFile.first(:name => params[:file_name]).code
	end
	get '/code/:klass' do
		content_type 'text/plain'
		Klass.first(:name => params[:klass]).code
	end

	def editor
			parse_error = nil
			rb = nil
		if params[:code] and params[:name]
			rb = RbFile.first_or_create({:name => params[:name]},{:code => params[:code], :code_hash => params[:code].hash})


			begin
				rb.parse
			rescue Exception => e 
				parse_error = e
			end
			
		end
	
		div {
			h1 "code"
			form(:action => "/editor", :enctype => "multipart/form-data", :method => "post") {
				_"save as" 
				input :type=>"textbox", :name=>"name", :value=>params[:name]
				br
				textarea params[:code], :name=>"code", :cols=>80, :rows=>30
				br
				input :type=>"submit", :name=>"save", :value=>"save"
				input :type=>"submit", :name=>"test", :value=>"test"
			}
			returned = nil
			parsed = nil

			begin
				parsed = ClassHerd::RbParser.new(params[:code]).parse
			rescue Exception => e
				h2 e.class
				i e.message
				div e.backtrace.join("<br>")
			#just catch the regular ruby syntax error.
			end
				if parse_error then
						h2 "#{parse_error.class} (error while parsing)"
						i parse_error.message
						div parse_error.backtrace.join("<br>")
				elsif rb
					test_results_for_class (rb.klasses.first)				
				end
					
					
				
				if parsed then
					h2 "parsed:"
					i parsed.classes.join(", ") 
				end
			begin
				out = StdoutCatcher.catch_out{
					returned = eval(params[:code]) if params[:code]
				}
			rescue Exception => e
				h2 e.class
				i e.message
				div e.backtrace.join("<br>")
			end

			h2 "output..."
			code (:lang => "ruby") {
				_ out
			}
			h2 "returned..."
			code (:lang => "ruby") {
				_ returned.inspect
			}
		}
	end

	post '/editor' do
		editor	
	end 
	get '/editor' do
		editor		
	end

	def link(klass,l=klass.name)
		a l, :href => "/klass/#{klass.name}"
	end


	def test_results (test,klass)

		TestRun.first(:test => r, :klass => k)
		
		table {
			tr {
				th "Class"
				th "time (s)"
			}
			v.each {|m|
				tr {
					td link(m.klass)
					td m.total_time.to_s
				}
			}
		}

	end
	
	def nav
		div(:style => "float:left;border:thin;height:1000px;padding-right:10px;") {
				b {a "home", :href => "/"}
				_ "<br>"
				_ "tests"
				_ "<br>"
				Klass.all.each {|k|  #(:is_test => true)
					link(k) 
					_ "<br>"
				}
		}
	
	end
	
	def test_table(hash)
		
		target,other = :klass,:test
		target,other = :test,:klass if hash.keys.include? :test
		
		table {
			tr {
				th other
				th "time"
				th "detail"
			}
			TestRun.all(hash).each{|r|
				tr {
					td link(r.method(other).call)
					td r.total_time
					td a(r.result,:href => "/test/#{r.test.name}/#{r.klass.name}")
				}
			}
		}
	end

	get '/retest/:klass_name' do
		begin 
			Klass.first(:name => params[:klass_name]).run_all_tests.inspect
		rescue Exception => e
			e.message		
		end
		
		#	TestRun.all.each{|r| r.run}
	end

	get '/test/:test_name/:klass_name' do
		test = Klass.first(:name => params[:test_name])
		klass = Klass.first(:name => params[:klass_name])
		run = TestRun.first(:klass => klass,:test => test)
		div {
			h2 {
				link(test)
				_".test(" 
				link(klass)
				_")"}
				
			table {
				tr {
					th "method"
					th "time"
					th "result"
					th "error"
					th "message"
				}
				run.test_run_methods.each{|e|
					tr{
						td e.method_name
						td e.time_taken
						td e.result, :class=>e.result
						td e.error
						td e.message
					}
					if e.error then
						tr{
							td (:COLSPAN=>5) {
								code e.trace.split("\n").join("<br>")
							}
						}
					end
				}		
			}		
		}
	end

	def test_results_for_class (k)
	
				h2 "tests"

				div test_table(:klass => k)#,:pass=>true)				
				
				if k.is_test then
					h2 "classes passed"
					div test_table(:test => k,:pass=>true)
				end
	
	end


	get '/klass/:klass_name' do
		#content_type 'text/plain'
		k = Klass.first(:name => params[:klass_name])

		html{
			body{
				h1 k.name
				a  "code", :href => "/code/#{params[:klass_name]}"
				test_results_for_class(k)

			}
		}
	end
	
	
	get '/' do
#		puts Klass.all.inspect
#		puts UnitTest.all.inspect
#		puts TestRun.all.inspect

		s = ""
		if params["couple"] then
			content_type 'text/plain'
			#klass = test_subs[params["couple"].to_sym].to_a.first
			#@lib.depends_for(klass.to_sym).each{|r|
			#	 a << File.open(r).read
			klass = Klass.first(:name => params["couple"].to_sym)
			a = [klass.name]
			
			a << klass.rb_files.map{|r| r.code}.join("\n")
			#}

			s << a.to_yaml
			s
		else
			html {
				body {
					nav
					h1 "Meta-Modular.com"
					div {
					h2 "Tests"
					
						ol {
							Klass.all(:is_test => true).each{|k|
								 li {
									h3 link(k)
								
									v = TestRun.all(:test => k, :pass => true)
									table {
										tr {
											th "Class"
											th "time (s)"
										}
										v.each {|m|
											tr {
												td link(m.klass)
												td m.total_time.to_s
											}
										}
									}
								}
							}
						}
					}
					form(:action => "./submit", :enctype => "multipart/form-data", :method => "post") {
						_"ruby file:"
						input :type=>"file", :name=>"rb_file"
						input :type=>"submit", :value=>"send"

					}
				}
			}
		end
	end
end

if __FILE__ == $0 then
	MetaModular.run! :host => 'localhost', :port => 5678
end

