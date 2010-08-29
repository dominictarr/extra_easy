
require 'rubygems'
require 'sinatra/base'
require 'dm_prod'
require 'model2'
require 'html_dsl'

class MetaModular < Sinatra::Base
	include HtmlDsl
	def initialize(app=nil)
		super(app)
#		puts "INITIALIZE"
#	@lib = LibraryDb.new
	end
#enable :inline_templates

#	def test_subs
#		@lib.passes
#	end

	post '/submit' do
#		content_type 'text/plain'

		rb = RbFile.load_rb(params['rb_file'][:tempfile])

		s = "#HOPE THIS LOADS THE CODE!\n" << 
		"#" << rb.inspect << 
		k = rb.parse
		redirect "/klass/#{k.first.name}"

	end
	get '/upload' do
		%{
			<form action="./submit" enctype="multipart/form-data" method="post" >
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

	def link(klass,l=klass.name)
		a l, :href => "/klass/#{klass.name}"
	end

	def test_results (test,klass)

		TestRun.first(:test => r, :klass => k)
		
#		v = TestRun.all(:test => k, :pass => true)
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
				}
				run.test_run_methods.each{|e|
					tr{
						td e.method_name
						td e.time_taken
						td e.result, :class=>e.result
					}			
				}		
			}		
		}
	end


	get '/klass/:klass_name' do
		#content_type 'text/plain'
		k = Klass.first(:name => params[:klass_name])

		html{
			body{
				h1 k.name
				a  "code", :href => "/code/#{params[:klass_name]}"
				h2 "tests"

				div test_table(:klass => k)#,:pass=>true)				
				
				if k.is_test then
					h2 "classes passed"
					div test_table(:test => k,:pass=>true)
				end
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

