module Vice
	class Vice
		attr_accessor :buffers
		attr_accessor :mode
		attr_accessor :cursor

		def initialize
			@mode = :command
			@buffers = Array.new
			@parser = Parser.new
		end

		def start
			# for now: create a single buffer
			@buffers.push Buffer.new nil, nil

			loop do
			end
		end
	end
end

require_relative "vice/buffer"
require_relative "vice/cursor"
require_relative "vice/parser"
