class Vice::Parser
	def initialize
		@current_command = ''
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
		raise 'prompt parser called from wrong mode' unless vice.mode == :prompt

		case char
		when 10 # enter
			Vice::Prompt.parse vice, vice.prompt, vice.buffers[current_buffer]
			vice.prompt = ''
			vice.mode = :command
		when 27 # escape
			vice.prompt = ''
			vice.mode = :command
		when 127 # backspace
			vice.prompt = vice.prompt[0..-2]
		when Integer
			vice.prompt += char if char >= 0 && char <= 10
		else
			vice.prompt += char
		end
	end

	def parsechar_command(vice, current_buffer, char)
		buffer = vice.buffers[current_buffer]
		raise 'command parser called from wrong mode' unless vice.mode == :command

		if %i[mark_set mark_jump].include? @current_command
			Vice::KeyPress.public_send(@current_command, vice, buffer, char)
			@current_command = ''
			return
		end

		@current_command += char
		if !vice.config[:keys][@current_command].nil?
			command = vice.config[:keys][@current_command]
			if %i[mark_set mark_jump].include? command
				@current_command = command
			else
				Vice::KeyPress.public_send(command, vice, buffer)
				@current_command = ''
			end
		else
			keep_current = false
			vice.config[:keys].each do |k|
				keep_current = true if k[0].start_with? @current_command
			end
			@current_command = '' unless keep_current
		end
	end

	def parsechar_insert(vice, current_buffer, char)
		buffer = vice.buffers[current_buffer]
		raise 'insert parser called from wrong mode' unless vice.mode == :insert
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
			if buffer.cursor.col.positive?
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
