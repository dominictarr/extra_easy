require 'stringio'
module StdoutCatcher

	def self.catch_out
		x = $stdout
      s = StringIO.new
		$stdout = s
		yield
		$stdout = x
      s.rewind
      s.read
	end
end

