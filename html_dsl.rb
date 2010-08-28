

module HtmlDsl

	class DslWorker 
		include HtmlDsl
		def tag_list
			@tag_list
		end
		def initialize(block)
			@tag_list = []
			last = instance_exec(&block)
			@tag_list << last if last != @tag_list.last
			return @tag_list.join("\n")
		end
		def html
			tag_list.join("\n")
		end
	end

def whitespaceless_compare(s1,s2)
	return s1.gsub(/\s/,'') == s2.gsub(/\s/,'')
end

def attrs (hash)
	
	s = ""
	hash.each{|k,v|
		s << " #{k}=\"#{v}\""
	}
	s
end
def text *t
	@tag_list << t.join("\n")
end
def tag(name, *args, &block)

	@tag_list = [] unless (@level ||= 0) > 0
	@level += 1
	old_tags = @tag_list
	tags = @tag_list = []
	hash = {}
	text = []
	args.each{|e|
		case e
			when Hash then
				hash.merge! e 
			else
				old_tags.pop if e == old_tags.last
				text << e
			end
	}

	tags << "<#{name}#{attrs(hash)}>"
	tags << text
	
	block.call if block

	tags <<  "</#{name}>"

	@tag_list = old_tags << tags
	@level -= 1
	return @tag_list.join  if @level == 0
	tags
end

def h1 hash={}, &block
	tag(:h1,hash,&block)
end

def self.deftag (*names)
	names.each{|name|
		eval "def #{name} *args,&block; tag(\"#{name}\",*args,&block); end"
	}
end

def _ *args
	text *args
end

deftag :table,:tr,:th,:td

deftag :div,:span, :p

deftag :i,:b,:em
deftag :a

deftag :h1,:h2,:h3,:h4,:h5,:h6

deftag :title

deftag :html,:head,:body

deftag :ul,:ol,:li

deftag :form,:input

#use meta programming to create other tags.
#also... execute blocks in context of some class... so you can see all the tags created within a tag?

end
