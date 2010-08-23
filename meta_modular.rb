
require 'rubygems'
require 'sinatra/base'
require 'dm_prod'
require 'library_db'
#require 'model2'

class MetaModular < Sinatra::Base

	def initialize(app=nil)
		super(app)
		puts "INITIALIZE"
	@lib = LibraryDb.new
	end

	def test_subs
		@lib.passes
	end

	post '/submit' do
		content_type 'text/plain'
		puts params.inspect

		@lib.add_depends(params['class_name'].to_sym, params['rb_file'][:tempfile])
		@lib.add(params['class_name'].to_sym)
		"submitted? "

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
		puts Klass.all.inspect
		puts UnitTest.all.inspect
		puts TestRun.all.inspect

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
		else
		s = "<ol>"
		test_subs.each{|k,v|
			s << "  <li>"
			s << "  <a href=\"./?couple=#{k}\">#{k}</a><br>\n"
			s << "  <ol><li>#{v.join("</li><li>")}</li></ol>\n"
			s << "  </li>"
		}
		s << "</ol>"
		s << `ruby -version`
		end
		s
	end
end

if __FILE__ == $0 then
	MetaModular.run! :host => 'localhost', :port => 5678
end
