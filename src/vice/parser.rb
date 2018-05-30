class Vice::Parser
	def initialize
		resettrail
	end

	def resettrail
		@trail = Array.new
	end

	def parsechar(vice, buffer, char)
		raise "parsechar called from command mode" unless vice.mode == :command
		case char
		# movement
		when 'j'
			if vice.buffers[buffer].lines > vice.buffers[buffer].cursor.line + 1
				vice.buffers[buffer].cursor.line += 1
			end
		when 'k'
			if vice.buffers[buffer].cursor.line - 1 >= 0
				vice.buffers[buffer].cursor.line -= 1
			end
		when 'l'
			if vice.buffers[buffer].cols > vice.buffers[buffer].cursor.col + 1
				vice.buffers[buffer].cursor.col += 1
			end
		when ';'
			if vice.buffers[buffer].cursor.col - 1 >= 0
				vice.buffers[buffer].cursor.col -= 1
			end

		# entering insert mode
		when 'i'
			vice.mode = :insert
		when 'O'
			vice.buffers[buffer].newline vice.cursor.line
			vice.buffers[buffer].cursor.line += 1
			vice.buffers[buffer].cursor.col = 0
			vice.mode = :insert
		when 'o'
			vice.buffers[buffer].newline vice.cursor.line
			vice.buffers[buffer].cursor.line += 1
			vice.buffers[buffer].cursor.col = 0
			vice.mode = :insert
		end
	end

	def insertchar(vice, buffer, char)
		raise "insertchar called from insert mode" unless vice.mode == :insert
		case char
		when 'x' # TODO: change this to escape
			vice.mode = :command
		else
			vice.buffers[buffer].insert char
			vice.buffers[buffer].cursor.col += 1
		end
	end
end
