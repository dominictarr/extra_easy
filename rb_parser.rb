require 'parser'
#require 'sexp_processor'

module ClassHerd
class RbParser < SexpProcessor
	attr_accessor :classes
	def initialize(file)
		@file = file
		@classes = []
		@namespace = []
	
		#File.open(file).read
		super()
	        unsupported= [] 
	end
	def parse
		#puts @file
		if @file.is_a? File or File.exists? @file then
			process(Parser.parse_file(@file))
		elsif @file.is_a? String then
			#puts "IT'S A STINGS"
			process(Parser.parse_code(@file))
		end
		self
	end
	def handle_const (exp)
		sym = exp.shift
		if sym == :const then
			return exp.shift
		elsif sym == :colon2
			#	(sym == :colon2) then
			return :"#{handle_const(exp.shift)}::#{exp.shift}" #inner sexp's
		else
			raise "Expected :colon2 or :const but found #{sym}"
		end
	end
	def handle_class_name(exp)
		if exp.nil? then
			return :Object
		elsif(Symbol === exp) then
			return exp
		elsif (Sexp === exp) then
			return handle_const(exp)
		end
	end
	def add_name
		@classes << @namespace.join("::").to_sym
	end
	def process_module (exp)
		exp.shift
		name = handle_class_name(exp.shift)
		@namespace.push name
		add_name
		sexp = s(:module, name, process(exp.shift))
		@namespace.pop
		sexp
	end
	def process_class (exp)
		#puts exp.inspect
		exp.shift
		name = handle_class_name(exp.shift)
		##exp.shift#ignore superclass#	
		begin
			superclass = handle_class_name(exp.shift)
		rescue Exception => e
			puts "weird superclass on #{name} -> #{e}"
			superclass = nil
		end 
			

		@namespace.push name
		puts @namespace.inspect
		add_name
		sexp = s(:class,name,superclass,	process(exp.shift))		 
		@namespace.pop
		sexp
	end
	#hey! if i'm gonna process all the classes here, do I need to parse the classes?
	#i.e. do i need ParseTree - if not then i'm compatible with 1.9	
	#def
end;end
