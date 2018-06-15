require 'curses'
require 'yaml'

module Vice
	class Vice
		attr_accessor :buffers
		attr_accessor :current_buffer
		attr_accessor :cursor
		attr_accessor :mode
		attr_accessor :prompt

		attr_reader :msg
		attr_reader :config

		def initialize(filenames)
			init_config

			@mode = :command
			@buffers = []
			@parser = Parser.new
			@prompt = ''

			@current_buffer = 0
			if filenames.nil? || filenames.empty?
				@buffers.push Buffer.new nil
			else
				filenames.each do |f|
					@buffers.push Buffer.new(f)
					next_buffer
				end
			end
		end

		def init_config
			defaults = { 'tab_width' => 4 } # defaults

			configfile = "#{Dir.home}/.vicerc"
			user_defined = File.open(configfile) { |f| YAML.safe_load(f.read) } if File.file? configfile

			@config = user_defined.nil? ? defaults : defaults.merge(user_defined)
		end

		def start
			Curses.init_screen
			Curses.noecho
			Curses.start_color
			Curses.use_default_colors
			window = Curses.stdscr

			blitter = Blitter.new window

			alert "welcome to vice #{VERSION} - https://github.com/knarka/vice"

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

require_relative 'vice/version'
require_relative 'vice/buffer'
require_relative 'vice/cursor'
require_relative 'vice/parser'
require_relative 'vice/blitter'
require_relative 'vice/movement'
require_relative 'vice/prompt'
