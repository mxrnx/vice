class Vice::Parser
	def initialize
		resettrail
	end

	def resettrail
		@trail = Array.new
	end

	def parsekeypress(vice, buffer, char)
		if vice.mode == :command
			parsechar_command vice, buffer, char
		elsif vice.mode == :insert
			parsechar_insert vice, buffer, char
		elsif vice.mode == :prompt
			parsechar_prompt vice, buffer, char
		else
			raise "parsekeypress called with unknown mode"
		end
	end

	def parsechar_prompt(vice, current_buffer, char)
		case char
		when 10
			Vice::Prompt.parse vice, vice.prompt, vice.buffers[current_buffer]
			vice.prompt = ""
			vice.mode = :command
		when 27
			vice.prompt = ""
			vice.mode = :command
		when Integer
			# do nothing
		else
			vice.prompt += char
		end
	end

	def parsechar_command(vice, current_buffer, char)
		buffer = vice.buffers[current_buffer]
		raise "parsechar called from command mode" unless vice.mode == :command
		case char
		# movement
		when 'j'
			buffer.cursor_down
		when 'k'
			buffer.cursor_up
		when 'l'
			buffer.cursor_right
		when 'h'
			buffer.cursor_left
		when 'w'
			buffer.cursor.col = Vice::Movement.w(buffer.currentline, buffer.cursor.col)
		when 'W'
			buffer.cursor.col = Vice::Movement.W(buffer.currentline, buffer.cursor.col)
		when 'b'
			buffer.cursor.col = Vice::Movement.b(buffer.currentline, buffer.cursor.col)
		when 'B'
			buffer.cursor.col = Vice::Movement.B(buffer.currentline, buffer.cursor.col)
		when '$'
			buffer.cursor.col = Vice::Movement.dollar buffer.currentline
		when '0'
			buffer.cursor.col = Vice::Movement.zero

		# entering insert mode
		when 'I'
			buffer.cursor.col = 0
			vice.mode = :insert
		when 'i'
			vice.mode = :insert
		when 'A'
			buffer.cursor.col = buffer.cols
			vice.mode = :insert
		when 'a'
			buffer.cursor.col += 1 if buffer.cursor.col < buffer.cols
			vice.mode = :insert
		when 'O'
			buffer.newline buffer.cursor.line
			buffer.cursor.col = 0
			vice.mode = :insert
		when 'o'
			buffer.newline buffer.cursor.line + 1
			buffer.cursor_down
			vice.mode = :insert

		# etc.
		when 'x'
			buffer.rmchar
			buffer.cursor.col -= 1 if buffer.cursor.col == buffer.cols
		when 'd'
			if @trail.length > 0 && @trail[0] == 'd'
				if buffer.lines == 1
					buffer.setline 0, ""
				else
					buffer.rmline
					buffer.cursor.line -= 1 if buffer.lines <= buffer.cursor.line
				end
				buffer.cursor.col = 0
				@trail = Array.new
			else
				@trail.push 'd'
			end
		when ";", ":"
			vice.mode = :prompt
		end
		buffer.cursor_end_of_line
	end

	def parsechar_insert(vice, current_buffer, char)
		buffer = vice.buffers[current_buffer]
		raise "insertchar called from insert mode" unless vice.mode == :insert
		case char
		when 27 # escape
			vice.mode = :command
			buffer.cursor_end_of_line
		when 127 # backspace
			if buffer.cursor.col > 0
				buffer.cursor.col -= 1
				buffer.rmchar
			end
		when 10 # return
			buffer.newline buffer.cursor.line + 1
			buffer.cursor_down
		when Integer
			# not a character we can insert, do nothing
		else
			buffer.insert char
			buffer.cursor.col += 1
		end
	end
end
