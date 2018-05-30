require 'curses'

class Vice::Blitter
	def initialize
	end

	def drawstatus(mode, window, buffer)
		window.setpos Curses.lines - 1, 0
		modestring = if mode == :insert 
			"-- insert --"
		else
			"            "
		end
		window.addstr modestring

		window.setpos Curses.lines - 1, Curses.cols - 10
		window.addstr buffer.cursor.line.to_s + "," + buffer.cursor.col.to_s
	end

	def pad(string, cols)
		delta = Curses.cols - string.length
		if delta > 0
			delta.times do string += ' ' end
		end
		return string
	end

	def drawbuffer(mode, window, buffer)
		(0..buffer.lines - 1).each do |i|
			if i < Curses.lines - 1
				window.setpos i, 0
				window.addstr pad(buffer.getline(i), Curses.cols)
			end
		end

		drawstatus mode, window, buffer

		window.setpos buffer.cursor.line, buffer.cursor.col
		window.refresh
	end
end
