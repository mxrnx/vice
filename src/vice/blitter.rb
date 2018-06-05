class Vice::Blitter
	def initialize(window)
		Curses.init_pair 1, Curses::COLOR_BLACK, Curses::COLOR_WHITE
		window.attrset Curses.color_pair(0)
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

	def drawalert(vice, window)
		window.setpos Curses.lines - 1, 0
		window.addstr " " * Curses.cols

		if vice.msg
			window.setpos Curses.lines - 1, 0
			window.addstr vice.msg

			vice.reset_alert
		end
	end

	def drawstatus(mode, window, buffer, prompt)
		window.attrset Curses.color_pair(1)

		# clear
		window.setpos Curses.lines - 2, 0
		window.addstr " " * Curses.cols

		# draw mode
		window.setpos Curses.lines - 2, 0
		modestring = if mode == :insert
				     " -- insert --"
			     elsif mode == :prompt
				     ":" + prompt
			     end
		window.addstr modestring

		# draw cursor position
		location = buffer.cursor.line.to_s + "," + buffer.cursor.col.to_s
		window.setpos Curses.lines - 2, Curses.cols - location.length - 1
		window.addstr location

		window.attrset Curses.color_pair(0)
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
		visual_cursor = Vice::Cursor.new buffer.cursor.line, 0

		(0..buffer.cursor.col - 1).each do |i|
			visual_cursor.col += if buffer.currentline[i] == "\t" 
						     Vice::TAB_WIDTH
					     else
						     1
					     end
		end


		drawtabs vice, buffer, window

		@linenumwidth = buffer.lines.to_s.length + 1
		(1..Curses.lines - 2).each do |r|
			i = r - 1
			window.setpos r, 0
			if i < buffer.lines
				window.addstr formatnumber(i + 1) + pad(buffer.getline(i).gsub(/(\t)/, ' ' * Vice::TAB_WIDTH), Curses.cols)
			else
				window.addstr pad(formatnumber('~'), Curses.cols)
			end
		end

		drawstatus vice.mode, window, buffer, vice.prompt
		
		drawalert vice, window

		visual_cursor.line += 1			# space for tabs above buffer
		visual_cursor.col += @linenumwidth + 1	# leave space for line numbers

		if vice.mode == :prompt
			window.setpos Curses.lines - 2, vice.prompt.length + 1
		else
			window.setpos visual_cursor.line, visual_cursor.col
		end
		window.refresh
	end
end
