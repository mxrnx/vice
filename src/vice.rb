require 'curses'

module Vice
	TAB_WIDTH = 4

	class Vice
		attr_accessor :buffers
		attr_accessor :currentbuffer
		attr_accessor :cursor
		attr_accessor :mode
		attr_accessor :prompt

		attr_reader :msg

		def initialize
			@mode = :command
			@buffers = Array.new
			@parser = Parser.new
			@prompt = ""
		end

		def start
			# for now: create a single buffer
			@buffers.push Buffer.new nil
			@currentbuffer = 0

			Curses.init_screen
			Curses.noecho
			Curses.start_color
			Curses.use_default_colors
			window = Curses.stdscr

			blitter = Blitter.new window

			loop do
				blitter.drawbuffer self, window
				key = window.getch
				@parser.parsekeypress self, @currentbuffer, key
			end

			Curses.close_screen
		end

		def alert(msg)
			@msg = msg
		end

		def error(msg)
			@msg = 'error: ' + msg
		end

		def reset_alert
			@msg = nil
		end
	end
end

require_relative "vice/buffer"
require_relative "vice/cursor"
require_relative "vice/parser"
require_relative "vice/blitter"
require_relative "vice/movement"
require_relative "vice/prompt"
