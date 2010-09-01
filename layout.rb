
require 'quick_attr'
require 'html_dsl'

class Layout

extend QuickAttr;
include HtmlDsl;
quick_attr :side_menu, :content, :header, :page_title, :top_menu

def shadow_box css_class,&block

	div(:class => css_class) { #has size
 		div(:class => "shadow") {
	 		div(:class => "inner", &block)
		}
	} 

end

def render_header 
#	div (:class => "shadow"){

		shadow_box(:header) {
			h1 header
		} 
#	} if header
end
def render_side_menu
		shadow_box(:side_menu) {
				side_menu.each {|e|
					_ e
					br
				}
		} if side_menu
#	} 
end
def render_content
		shadow_box(:content) {
				if content.is_a? Array then
						
						content.each {|e|
						 p e
						 _ "<hr/>"
						}
				else
					_ content			
				end
		}
end

def render
	html{
		head {
			title page_title if page_title
			style %{
				
				.header {
					margin-top:50px;
					margin-left:50px;
					padding-left: 0px;
					width: 900px;
				}	
				.side_menu {
					margin-left:50px;
					width:150px;
					float:left;
				}
				.content {
					border:none 0px;
					line-height:140%;
					margin-left:225px;
					width:725px;
				}	
				.shadow {
					margin-top:25px;
					background: #3f3;
				   border:solid;
					border-width:1px;
					border-color:#aaa;
				}
				.inner {
				   border:solid;
					border-width:1px;
					background: #fff;
					color: #333;
					position:relative;
					padding: 10px;
					top: -10px;
					left: -7px;
				}
				body {
					font-family:Helvetica,Arial, sans-serif;;
					background:#113;
					line-height:140%;			
				}
			},:type=>"text/css"
		}
		body {
			render_header
			render_side_menu
			render_content
		}
	}
end
end

if __FILE__ == $0 then
	l = Layout.new.side_menu(:hello,:side,:menu).header(:HELLO_OWO_OW).content %{
		<h2>HI!</h2>
		<hr/>
		Sdaflas sdjfla ssdfgf uiowe xcv dsdf 
		cvhx Df saodfasdhfhaiouf haw sdnkvnsdvjrv
		cvhx df saodfasdhfhaiouf haw sdnkvnsdvjrv	
		cvhx df saodfasdhfhaiouf haw sdnkvnsdvjrv
		vdf saodfasdhf df saodfasdhf
		sdfajsdfl asdlfkja sdlasduf d sudfjdfjsd ADasd asdhaskd h
		df saodfasdhf
	
	}
	puts l.render


end
