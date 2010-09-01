require 'rubygems'
require 'sinatra/base'
require 'dm_prod'
require 'model2'
require 'html_dsl'
require 'modules/stdout_catcher'
require 'rb_parser'
require 'adaptable_test'
require 'meta_modular_views'

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

		upload
	end
	get '/rb_file/:file_name' do
		code(RbFile.first(:name => params[:file_name]))
	end
	get '/code/:klass' do
		content_type 'text/plain'
		code_view(Klass.first(:name => params[:klass]))
	end

	def editor
			parse_error = nil
			rb = nil
		if params[:code] and params[:name]
			rb = RbFile.first_or_create({:name => params[:name]},{:code => params[:code], :code_hash => params[:code].hash})
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

			#just catch the regular ruby syntax error.
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
	
	get '/retest/:klass_name' do
		begin 
			Klass.first(:name => params[:klass_name]).run_all_tests.inspect
		rescue Exception => e
			e.message		
		end
		
		#	TestRun.all.each{|r| r.run}
	end


	get '/test/:test_name/:klass_name' do
		run = TestRun.first(:klass => {:name => params[:klass_name]},:test => {:name => params[:test_name]})
		test_run(run)
	end




	get '/klass/:klass_name' do
		#content_type 'text/plain'
		k = Klass.first(:name => params[:klass_name])
		klass_view(k)
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
			home
		end
	end
end

if __FILE__ == $0 then
	MetaModular.run! :host => 'localhost', :port => 5678
end

