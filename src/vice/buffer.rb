class Vice::Buffer
	attr_reader :buffer
	attr_reader :filename
	attr_reader :modified
	attr_accessor :cursor

	def initialize(filename)
		@buffer = Array.new
		if filename
			@filename = filename
			File.open(filename, "r") do |f| # TODO: don't assume file exists
				f.each_line do |line|
					@buffer.push line
				end
			end
		else
			@buffer.push ""
		end
		@cursor = Vice::Cursor.new
		@modified = false
	end

	def write(filename)
		@modified = false
	end

	def write
		write @filename
	end

	def cursor_end_of_line
		if @cursor.col > @buffer[@cursor.line].length # move curosr to end of line
			@cursor.col = @buffer[@cursor.line].length
		end
	end

	def cursor_up
		if @cursor.line > 0
			@cursor.line -= 1
		end
		cursor_end_of_line
	end

	def cursor_down
		if @cursor.line < @buffer.length - 1
			@cursor.line += 1
		end
		cursor_end_of_line
	end

	def cursor_left
		if @cursor.col > 0
			@cursor.col -= 1
		end
	end

	def cursor_right
		if @cursor.col < @buffer[@cursor.line].length
			@cursor.col += 1
		end
	end

	def newline(index)
		raise "negative line index" unless index >= 0

		@modfied = true

		# silently append to the end when index out of bounds
		index = @buffer.length if index > @buffer.length

		@buffer.insert index, ""
	end

	def rmline(index)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length

		@modfied = true

		@buffer.delete_at index
	end

	def insertf(index, column, text)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length
		raise "negative column index" unless column >= 0
		raise "column index out of bounds" unless column <= @buffer[index].length

		@modfied = true

		@buffer[index].insert column, text
	end

	def insert(text)
		insertf @cursor.line, @cursor.col, text
	end

	def rmcharf(index, column)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length
		raise "negative column index" unless column >= 0
		raise "column index out of bounds" unless column <= @buffer[index].length

		@modfied = true

		@buffer[index].slice! column
	end

	def rmchar
		rmcharf @cursor.line, @cursor.col
	end

	def setline(index, text)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length

		@modfied = true

		@buffer[index] = text
	end

	def getline(index)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length

		return @buffer[index]
	end

	def currentline
		getline @cursor.line
	end

	def lines
		return @buffer.length 
	end

	def cols
		return @buffer[@cursor.line].length
	end
end
