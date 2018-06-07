require 'curses'

module Vice
	TAB_WIDTH = 4

	class Vice
		attr_accessor :buffers
		attr_accessor :current_buffer
		attr_accessor :cursor
		attr_accessor :mode
		attr_accessor :prompt

		attr_reader :msg

		def initialize
			@mode = :command
			@buffers = []
			@parser = Parser.new
			@prompt = ''

			# for now: create a single buffer
			@buffers.push Buffer.new nil
			@current_buffer = 0
		end

		def start
			Curses.init_screen
			Curses.noecho
			Curses.start_color
			Curses.use_default_colors
			window = Curses.stdscr

			blitter = Blitter.new window

			loop do
				blitter.drawbuffer self, window
				key = window.getch
				@parser.parsekeypress self, @current_buffer, key
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

		def next_buffer
			@current_buffer += 1
			@current_buffer = 0 if @current_buffer >= @buffers.length
		end

		def prev_buffer
			@current_buffer -= 1
			@current_buffer = @buffers.length - 1 if @current_buffer < 0
		end
	end
end

require_relative 'vice/buffer'
require_relative 'vice/cursor'
require_relative 'vice/parser'
require_relative 'vice/blitter'
require_relative 'vice/movement'
require_relative 'vice/prompt'
