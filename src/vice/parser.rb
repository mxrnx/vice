class Vice::Parser
	def initialize
		resettrail
	end

	def resettrail
		@trail = Array.new
	end

	def parsekeypress(vice, buffer, char)
		if vice.mode == :command
			parsechar vice, buffer, char
		elsif vice.mode == :insert
			insertchar vice, buffer, char
		else
			raise "parsekeypress called with unknown mode"
		end
	end

	def fixcursorposition(vice, buffer)
		if vice.buffers[buffer].cols == 0
			vice.buffers[buffer].cursor.col = 0
		elsif vice.buffers[buffer].cols <= vice.buffers[buffer].cursor.col + 1
			vice.buffers[buffer].cursor.col = vice.buffers[buffer].cols - 1
		end
	end

	def parsechar(vice, buffer, char)
		raise "parsechar called from command mode" unless vice.mode == :command
		case char
		# movement
		when 'j'
			vice.buffers[buffer].cursor_down
		when 'k'
			vice.buffers[buffer].cursor_up
		when 'l'
			vice.buffers[buffer].cursor_right
		when 'h'
			vice.buffers[buffer].cursor_left
		when 'w'
			vice.buffers[buffer].cursor.col = Vice::Movement.w(vice.buffers[buffer].currentline, vice.buffers[buffer].cursor.col)
		when 'W'
			vice.buffers[buffer].cursor.col = Vice::Movement.W(vice.buffers[buffer].currentline, vice.buffers[buffer].cursor.col)
		when 'b'
			vice.buffers[buffer].cursor.col = Vice::Movement.b(vice.buffers[buffer].currentline, vice.buffers[buffer].cursor.col)
		when 'B'
			vice.buffers[buffer].cursor.col = Vice::Movement.B(vice.buffers[buffer].currentline, vice.buffers[buffer].cursor.col)

		# entering insert mode
		when 'I'
			vice.buffers[buffer].cursor.col = 0
			vice.mode = :insert
		when 'i'
			vice.mode = :insert
		when 'A'
			vice.buffers[buffer].cursor.col = vice.buffers[buffer].cols
			vice.mode = :insert
		when 'a'
			vice.buffers[buffer].cursor.col += 1 if vice.buffers[buffer].cursor.col < vice.buffers[buffer].cols
			vice.mode = :insert
		when 'O'
			vice.buffers[buffer].newline vice.buffers[buffer].cursor.line
			vice.buffers[buffer].cursor.col = 0
			vice.mode = :insert
		when 'o'
			vice.buffers[buffer].newline vice.buffers[buffer].cursor.line + 1
			vice.buffers[buffer].cursor_down
			vice.mode = :insert

		# etc.
		when 'x'
			vice.buffers[buffer].rmchar
			vice.buffers[buffer].cursor.col -= 1 if vice.buffers[buffer].cursor.col == vice.buffers[buffer].cols
		end
	end

	def insertchar(vice, buffer, char)
		raise "insertchar called from insert mode" unless vice.mode == :insert
		case char
		when 27 # escape
			vice.mode = :command
		when 127 # backspace
			if vice.buffers[buffer].cursor.col > 0
				vice.buffers[buffer].cursor.col -= 1
				vice.buffers[buffer].rmchar
			end
		when 10 # return
			vice.buffers[buffer].newline vice.buffers[buffer].cursor.line + 1
			vice.buffers[buffer].cursor_down
		when Integer
			# not a character we can insert, do nothing
		else
			vice.buffers[buffer].insert char
			vice.buffers[buffer].cursor.col += 1
		end
	end
end
