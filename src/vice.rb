require 'curses'

module Vice
	class Vice
		attr_accessor :buffers
		attr_accessor :mode
		attr_accessor :cursor
		attr_accessor :currentbuffer

		def initialize
			@mode = :command
			@buffers = Array.new
			@parser = Parser.new
		end

		def start
			blitter = Blitter.new

			# for now: create a single buffer
			@buffers.push Buffer.new nil, nil
			@currentbuffer = 0

			Curses.init_screen
			Curses.noecho
			window = Curses.stdscr

			loop do
				blitter.drawbuffer(@mode, window, @buffers[@currentbuffer])
				key = window.getch
				@parser.parsekeypress self, @currentbuffer, key
			end

			Curses.close_screen
		end
	end
end

require_relative "vice/buffer"
require_relative "vice/cursor"
require_relative "vice/parser"
require_relative "vice/blitter"
