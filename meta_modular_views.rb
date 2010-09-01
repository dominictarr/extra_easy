#meta_modular_views
require 'layout'

class MetaModular < Sinatra::Base
	include HtmlDsl
	def upload
			%{
				<form action="/submit" enctype="multipart/form-data" method="post" >
				ruby file:
				<input type=file name="rb_file">
				<input type=submit  value="Send">
				</form>			
			}

	end
	def code_view  (obj)
			content_type 'text/plain'
			return obj.code
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
			[b {a "home", :href => "/"}] +
			Klass.all.collect {|k|
				link(k) 
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
def test_run (run)
		test = run.test
		klass = run.klass
		
		Layout.new.header(link(test) + ".test(" + link(klass) + ")").side_menu(nav).content(
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
		).render	
end

	def home
		Layout.new.header("Meta-Modular").side_menu(nav).content(
			Klass.all(:is_test => true).collect{|k|
				div{
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
								td a(m.total_time.to_s,:href => "/test/#{m.test.name}/#{m.klass.name}")
							}
						}
					}
				}
			} << form(:action => "./submit", :enctype => "multipart/form-data", :method => "post") {
				_"ruby file:"
				input :type=>"file", :name=>"rb_file"
				input :type=>"submit", :value=>"send"
			}
		).render
	
	end
	def klass_view(k)
		Layout.new.header(k.name).side_menu(nav).content(
			div {
				a  "code", :href => "/code/#{params[:klass_name]}" 
				test_results_for_class(k)
			}
		).render
	end

	def test_results_for_class (k)
	
				h2 "tests"

				div test_table(:klass => k)#,:pass=>true)				
				
				if k.is_test then
					h2 "classes passed"
					div test_table(:test => k,:pass=>true)
				end
	
	end


end

