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
		code_view(RbFile.first(:name => params[:file_name]))
	end
	get '/code/:klass' do
		content_type 'text/plain'
		code_view(Klass.first(:name => params[:klass]))
	end
	get '/couple/:test' do
		content_type 'text/plain'
		klass = Klass.first(:name => params[:test])
		puts klass.inspect
		if klass.is_test then
			klass = klass.klasses_passed.first
		end
		a = [klass.name]
		a << klass.code
		s = "" << a.to_yaml
		puts s
		s
	end

	def save_edit (rb_name,code)
			rb_file = RbFile.first_or_create(:name => params[:rb_file])

			rb_file.code = params[:code] || ""
			rb_file.code_hash = params[:code].hash
			rb_file.save
			rb_file.parse
	end

	def editor
		rb_file = RbFile.first(:name => params[:rb_file])
		run_error = nil
		returned = nil

		if rb_file then
			rb_file.parse unless rb_file.saved?
			begin
				output = StdoutCatcher.catch_out{
					returned = eval(rb_file.code) if rb_file
				}
			rescue Exception => e
				run_error = e
			end
		end
		editor_view rb_file,returned,output,run_error	
	end

	post '/save_edit' do
		puts "SAVE"
		puts params[:rb_file]
		#params[:code]
		save_edit (params[:rb_file],params[:code])
		redirect "/editor/#{params[:rb_file]}"
	end 
	get '/editor/:rb_file' do
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

		home
	end
end

if __FILE__ == $0 then
	MetaModular.run! :host => 'localhost', :port => 5678
end

