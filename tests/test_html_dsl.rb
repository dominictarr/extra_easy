
require "html_dsl"
require "adaptable_test"

class TestHtmlDsl < AdaptableTest


	def default_subject 
		HtmlDsl
	end
	def assert_same (s1,s2,msg = nil)
		assert(whitespaceless_compare(s1,s2),msg || "expected #{s1} but got #{s2}")
	end
	def test_attr
		assert_equal " a=\"1\"",attrs(:a => 1)		
		assert_equal " a=\"1\" b=\"2\"",attrs(:a => 1, :b => 2)		
	end
	
	def test_tag
		assert_same "<h a=\"1\" b=\"2\">hello</h>", tag(:h,:a => 1, :b => 2) {_ "hello"}
	end

	def test_multitag
		assert_same "<h><a></a><b></b></h>", tag(:h){
					tag(:a){}
					tag(:b){}
					}
	end

	def test_table
		assert_equal "<table><tr><td>cell</td></tr></table>", 
			table(tr(td("cell"))) #this format is not an advantage for nesting... same number of characters.
										#useful for a single string in the field though
	
	end

	def setup
		self.class.send :include, subject
	
	end
	def test_nice
		assert_same "<title>hello</title>", title("hello")
		assert_same "<head><title>hello</title></head>", head(title "hello")

		assert_same "<a href=\"here\">there</a>", a({:href=>"here"},"there")
		assert_same "<a href=\"here\">there</a>", a("there",:href=>"here")
		
		#assert_equal "<div id=\"content\">content div</div>", div("#content","content div") 
		
			#have htmldsl check the first args for special forms to convienently set some attrs...
			#.	#id
			#	.class
			# src:source;
			# attr:attribute;
		
	end
	
	def test_many
		h = div{
			ol{
				h1 {title "hello" }
				(1..5).each{|e|
					li i(e.to_s)
				}
			}
		
		}
		i = div{
			ol{
				h1 {title "hello" }
				(1..5).each{|e|
					li {i(e.to_s)}
				}
			}
		
		}
		c = "<div>
		<ol>
			<h1><title>hello</title></h1>
			<li><i>1</i></li>
			<li><i>2</i></li>
			<li><i>3</i></li>
			<li><i>4</i></li>
			<li><i>5</i></li>
		</ol>
		</div>"
		assert_same c,h, "expect #{c} == #{h} (ignoring w/s) even with li i(\"x\")"
		assert_same c,i, "expect #{c} == #{h} (ignoring w/s) even with li{i(\"x\")}"
	
#		fail "write improved tests to replicate whats happening in meta-modular."
	end
	
	def test_many2
	
		h = html head( title "hi"),body( div( h1("h1"),h2("h2""..!")))
		s = "<html>
			<head>
				<title> hi </title>
			</head>
			<body>
				<div>
					<h1>h1</h1>
					<h2>h2..!</h2>
				</div>
			</body>
		</html>"
#		puts "moresdj;"
		assert_same h,s
	end
	
	def test_whitespaceless_compare

			assert whitespaceless_compare("asdf", "a s d f")
			assert whitespaceless_compare("asdf", "a\ns\n\nd f")
	end
	
	def test
		raise "what about disabling @tags when you call text() so that it just works on strings which are returned.
	end
end

Mini::Test.autorun
