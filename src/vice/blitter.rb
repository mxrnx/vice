class Vice::Blitter
	def initialize
	end

	def drawstatus(mode, window, buffer)
		# clear
		window.setpos Curses.lines - 1, 0
		window.addstr " " * Curses.cols

		# draw mode
		window.setpos Curses.lines - 1, 0
		modestring = if mode == :insert 
			" -- insert --"
		else
			"             "
		end
		window.addstr modestring

		# draw cursor position
		location = buffer.cursor.line.to_s + "," + buffer.cursor.col.to_s
		window.setpos Curses.lines - 1, Curses.cols - location.length - 1
		window.addstr location
	end

	def formatnumber(number)
		if number == '~'
			delta = @linenumwidth - 1
		else
			delta = @linenumwidth - number.to_s.length
		end
		delta.times do
			number = ' ' + number.to_s
		end
		number += ' '
	end

	def pad(string, cols)
		delta = Curses.cols - string.length
		if delta > 0
			delta.times do string += ' ' end
		end
		return string
	end

	def drawbuffer(mode, window, buffer)
		@linenumwidth = buffer.lines.to_s.length + 1
		(0..Curses.lines - 1).each do |i|
			window.setpos i, 0
			if i < buffer.lines
				window.addstr formatnumber(i + 1) + pad(buffer.getline(i), Curses.cols)
			else
				window.addstr formatnumber('~')
			end
		end

		drawstatus mode, window, buffer

		window.setpos buffer.cursor.line, buffer.cursor.col + @linenumwidth + 1
		window.refresh
	end
end
