
module Psychic
	def self.make_args (arity)
		args = []
		var = nil
		if(arity == 0)
			return "&block"
		elsif (arity < 0)
			var = "*args"
			arity = (arity + 1) * -1
		end
		arity.times{|i| args << "arg#{i}"}
		if var then args << var; end
		args << "&block"
		return args.join(",")
	end

	def self.connect (object,*methods,&block)
		prefix = "psychic_"

		unless psyc_c = object.send(:instance_variable_get,:@psychic_connections) then
			object.send(:instance_variable_set,:@psychic_connections,psyc_c = Hash.new)
		end
		if block.nil? then
			raise "cannot make a psychic connection to #{object.inspect} without a block"
		end

		methods.each {|m|
			old_m = "#{prefix}#{m}"
	
			unless psyc_c[m] and !(psyc_c[m].empty?) then

			object.instance_eval "alias :\"#{old_m}\" :\"#{m}\""
			psyc_c[m] = [block]
			def object.psychic_connection (method, value,*args,&block)
				if psy = @psychic_connections[method] then
					psy.each{|b|
# argh! i've found another bug in ruby!
# def f (a,b,&block);end
# method(:f).arity == 2
# proc {|a,b,&block|}.arity == 1
					unless b.arity == -4 or (b.arity == 1 and b.is_a?(Proc)) then 
						raise "psychic connection needs arity of block to be -4, was=#{b.arity} 
	suggest these arguments: |object,method,value,*args,&block|"
					end
					b.call(self,method,value,*args,&block)
					}
				end
			end

			args = make_args(object.method(m).arity)
			object.instance_eval "def #{m}(#{args})
					value = method(:\"#{old_m}\").call(#{args})
					psychic_connection(:\"#{m}\",value,#{args})
					return value		
					end"
			else
			psyc_c[m] << block
			end
		}
	end
	def self.disconnect (object,*methods,&block)
		psyc_c = object.send(:instance_variable_get,:@psychic_connections)
		methods.each {|m|
			psyc_c[m].delete block
		}
	end
	def self.connect_mutable(object,&block) # connect to all mutable methods on certain core types.
		if object.is_a? Array then
			methods = [:"[]=",:"<<",:delete,:delete_at,:delete_if,:"flatten!",:insert,:"map!",:"collect!",:"slice!",:"uniq!",:"reverse!",:"compact!"]
			
		elsif object.is_a? Hash
			methods = [:"[]=",:"default=",:"merge!",:"reject!"]
		
		elsif object.is_a? String
			methods = [:"[]=",:"<<",:"capitalize!",:"chomp!",:"downcase!",:"gsub!",:"upcase!"]
		end
			connect(object,*methods,&block)
	end
end

