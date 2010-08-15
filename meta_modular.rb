
require 'rubygems'
require 'sinatra/base'
require 'yaml'
require 'library'

class MetaModular < Sinatra::Base

	def initialize(app=nil)
		super(app)
	@dir = Dir.new('./mm/')
	@lib = Library.new
	@lib.add_depends(:TestAdaptableTest,'tests/test_adaptable_test.rb')
	load
	end
	def filename
		@dir.path + "library.yaml"
	end

	def load
		@lib = YAML::load(File.open(filename,'r').read)
	end

	def save
		puts @lib.to_yaml
		f = File.new(filename,'w')
		f.write(@lib.to_yaml)
		f.close
	end

#	if File.exists? filename then
#		load 
#	end
	def test_subs
		@lib.passes
	end

	post '/submit' do
		content_type 'text/plain'
		#params.inspect + " " +  params['rb_file'].class.to_s
		puts params.inspect
		uploaded = params['rb_file'][:tempfile].read
		#write while into a safe directory somewhere.
		f = File.new(@dir.path + params['rb_file'][:filename],'w')
		puts f.path
		f.write(uploaded)
		f.close

		@lib.add_depends(params['class_name'].to_sym, f.path)
		@lib.add(params['class_name'].to_sym)
		save

		uploaded

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
#		return "HELKFALIASO"
		s = ""
		if params["couple"] then
			content_type 'text/plain'
			klass = test_subs[params["couple"].to_sym].to_a.first
			a = [klass.to_s]
			@lib.depends_for(klass.to_sym).each{|r|
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
	end
end

if __FILE__ == $0 then
	MetaModular.run! :host => 'localhost', :port => 5678
end
