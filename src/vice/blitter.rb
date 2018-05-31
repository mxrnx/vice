class Vice::Blitter
	def initialize
	end

	def drawtabs(vice, buffer, window)
		window.setpos 0, 0
		window.addstr " " * Curses.cols
		window.setpos 0, 3
		vice.buffers.each do |b|
			name = if b.filename then b.filename else '[no name]' end
			name = if b == buffer then ">" + name + "<" else name end
			name = if b.modified then "+ " + name else name end
			window.addstr name + " | "
		end
	end

	def drawstatus(mode, window, buffer, prompt)
		# clear
		window.setpos Curses.lines - 1, 0
		window.addstr " " * Curses.cols

		# draw mode
		window.setpos Curses.lines - 1, 0
		modestring = if mode == :insert
				     " -- insert --"
			     elsif mode == :prompt
				     ":" + prompt
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

	def drawbuffer(vice, window)
		buffer = vice.buffers[vice.currentbuffer]

		drawtabs vice, buffer, window

		@linenumwidth = buffer.lines.to_s.length + 1
		(1..Curses.lines - 1).each do |r|
			i = r - 1
			window.setpos r, 0
			if i < buffer.lines
				window.addstr formatnumber(i + 1) + pad(buffer.getline(i), Curses.cols)
			else
				window.addstr pad(formatnumber('~'), Curses.cols)
			end
		end

		drawstatus vice.mode, window, buffer, vice.prompt

		if vice.mode == :prompt
			window.setpos Curses.lines - 1, vice.prompt.length + 1
		else
			window.setpos buffer.cursor.line + 1, buffer.cursor.col + @linenumwidth + 1
		end
		window.refresh
	end
end
