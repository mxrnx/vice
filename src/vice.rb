require 'curses'

module Vice
	TAB_WIDTH = 4

	class Vice
		attr_accessor :buffers
		attr_accessor :mode
		attr_accessor :cursor
		attr_accessor :currentbuffer
		attr_accessor :prompt


		def initialize
			@mode = :command
			@buffers = Array.new
			@parser = Parser.new
			@prompt = ""
		end

		def start
			blitter = Blitter.new

			# for now: create a single buffer
			@buffers.push Buffer.new nil
			@currentbuffer = 0

			Curses.init_screen
			Curses.noecho
			window = Curses.stdscr

			loop do
				blitter.drawbuffer self, window
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
require_relative "vice/movement"
require_relative "vice/prompt"
