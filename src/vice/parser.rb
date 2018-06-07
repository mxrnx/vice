class Vice::Parser
	def initialize
		resettrail
	end

	def resettrail
		@trail = []
	end

	def parsekeypress(vice, buffer, char)
		if vice.mode == :command
			parsechar_command vice, buffer, char
		elsif vice.mode == :insert
			parsechar_insert vice, buffer, char
		elsif vice.mode == :prompt
			parsechar_prompt vice, buffer, char
		else
			raise 'parsekeypress called with unknown mode'
		end
	end

	def parsechar_prompt(vice, current_buffer, char)
		case char
		when 10
			Vice::Prompt.parse vice, vice.prompt, vice.buffers[current_buffer]
			vice.prompt = ''
			vice.mode = :command
		when 27
			vice.prompt = ''
			vice.mode = :command
		when Integer
			vice.prompt += char if char >= 0 && char <= 10
		else
			vice.prompt += char
		end
	end

	def parsechar_command(vice, current_buffer, char)
		buffer = vice.buffers[current_buffer]
		raise 'parsechar called from command mode' unless vice.mode == :command
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
			if !@trail.empty?
				if @trail[0] == 'd' || @trail[0] == 'c'
					line_edited = buffer.currentline
					right_limit = buffer.currentline.length
					right_limit -= Vice::Movement.w(buffer.currentline, buffer.cursor.col) - 1

					line_edited.slice! buffer.cursor.col, right_limit

					buffer.setline buffer.cursor.line, line_edited
				end
				vice.mode = :insert if @trail[0] == 'c'
				@trail = []
			else
				buffer.cursor.col = Vice::Movement.w(buffer.currentline, buffer.cursor.col)
			end
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
			buffer.cursor.col -= 1 if buffer.cursor.col > 0
		when 'c'
			if !@trail.empty? && @trail[0] == 'c'
				buffer.setline buffer.cursor.line, ''
				buffer.cursor.col = 0
				vice.mode = :insert
				@trail = []
			else
				@trail.push 'c'
			end
		when 'd'
			if !@trail.empty? && @trail[0] == 'd'
				if buffer.lines == 1
					buffer.setline 0, ''
				else
					buffer.rmline
				end
				buffer.cursor.line -= 1 if buffer.lines <= buffer.cursor.line
				buffer.cursor.col = 0
				@trail = []
			else
				@trail.push 'd'
			end
		when 'g'
			if !@trail.empty? && @trail[0] == 'g'
				buffer.cursor.line = 0
				buffer.cursor.col = 0
			else
				@trail.push 'g'
			end
		when 'G'
			buffer.cursor.line = buffer.lines - 1
			buffer.cursor.col = 0
		when 't'
			vice.next_buffer if !@trail.empty? && @trail[0] == 'g'
			@trail = []
		when 'T'
			vice.prev_buffer if !@trail.empty? && @trail[0] == 'g'
			@trail = []
		when ';', ':'
			vice.mode = :prompt
		end
	end

	def parsechar_insert(vice, current_buffer, char)
		buffer = vice.buffers[current_buffer]
		raise 'insertchar called from insert mode' unless vice.mode == :insert
		case char
		when 9
			buffer.insert "\t"
			buffer.cursor.col += 1
		when 10 # return
			buffer.newline buffer.cursor.line + 1
			buffer.cursor_down
		when 27 # escape
			vice.mode = :command
			buffer.cursor_end_of_line
		when 127 # backspace
			if buffer.cursor.col > 0
				buffer.cursor.col -= 1
				buffer.rmchar
			end
		when Integer
			vice.prompt += char if char >= 0 && char <= 10
		else
			buffer.insert char
			buffer.cursor.col += 1
		end
	end
end
