require 'ruby_parser'
#require 'parse_tree'
#require 'unified_ruby'
require 'sexp_processor'

module ClassHerd
module Parser
		def self.enable_c (sexp_p)
			sexp_p.unsupported=[]
	#		puts "UNSUPPORTED=#{sexp_p.unsupported}"
			sexp_p
		end
		def self.parse_file(filename)
			#if(File.new(filename).exists
			parse_code(File.open(filename).read)
		end
#		def self.parse_file_pt(filename)
#			parse_code_pt(File.open(filename).read)
#		end
		def self.parse_code(code)
			RubyParser.new.parse(code)
		end
#		def self.parse_code_pt(code)
#			fix_pt(ParseTree.new.parse_tree_for_string(code))
#		end
		def self.fix_pt(array)
			#u = enable_c(Unifier.new)
			#puts "UNSUPPORTED2=.=.=>#{u.unsupported}"
			#u.process(
					Sexp.from_array(
						array.first)
			#)
		end
#		def self.parse_class(klass)
			#Sexp.from_array(ParseTree.new.parse_tree(klass).first)
#			fix_pt(ParseTree.new.parse_tree(klass))
#		end
end;end
