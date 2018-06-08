class Vice::Buffer
	attr_reader :buffer
	attr_reader :filename
	attr_reader :modified
	attr_accessor :cursor
	attr_accessor :v_scroll

	def initialize(filename)
		@buffer = []
		if filename
			@filename = filename
			File.open(filename, 'r') do |f| # TODO: don't assume file exists
				f.each_line { |line| @buffer.push line.chomp }
			end
		else
			@buffer.push ''
		end
		@cursor = Vice::Cursor.new
		@modified = false
		@v_scroll = 0
	end

	def writef(filename)
		@modified = false

		File.open(filename, 'w') do |f|
			f.write @buffer.join "\n"
		end
	end

	def write
		writef @filename
	end

	def cursor_end_of_line
		# if we're out of bounds, move the cursor to the end of the line
		@cursor.col = @buffer[@cursor.line].length - 1 if @cursor.col >= @buffer[@cursor.line].length
		@cursor.col = 0 if @cursor.col < 0
	end

	def cursor_up
		@cursor.line -= 1 if @cursor.line > 0
		cursor_end_of_line
	end

	def cursor_down
		@cursor.line += 1 if @cursor.line < @buffer.length - 1
		cursor_end_of_line
	end

	def cursor_left
		@cursor.col -= 1 if @cursor.col > 0
	end

	def cursor_right
		@cursor.col += 1 if @cursor.col < @buffer[@cursor.line].length - 1
	end

	def newline(index)
		raise 'negative line index' unless index >= 0

		@modified = true

		# silently append to the end when index out of bounds
		index = @buffer.length if index > @buffer.length

		@buffer.insert index, ''
	end

	def rmlinef(index)
		raise 'negative line index' unless index >= 0
		raise 'line index out of bounds' unless index < @buffer.length

		@modified = true

		@buffer.delete_at index
	end

	def rmline
		rmlinef @cursor.line
	end

	def insertf(index, column, text)
		raise 'negative line index' unless index >= 0
		raise 'line index out of bounds' unless index < @buffer.length
		raise 'negative column index' unless column >= 0
		raise 'column index out of bounds' unless column <= @buffer[index].length

		@modified = true

		@buffer[index].insert column, text
	end

	def insert(text)
		insertf @cursor.line, @cursor.col, text
	end

	def rmcharf(index, column)
		raise 'negative line index' unless index >= 0
		raise 'line index out of bounds' unless index < @buffer.length
		raise 'negative column index' unless column >= 0
		raise 'column index out of bounds' unless column <= @buffer[index].length

		@modified = true

		@buffer[index].slice! column
	end

	def rmchar
		rmcharf @cursor.line, @cursor.col
	end

	def setline(index, text)
		raise 'negative line index' unless index >= 0
		raise 'line index out of bounds' unless index < @buffer.length

		@modified = true

		@buffer[index] = text
		cursor_end_of_line
	end

	def getline(index)
		raise 'negative line index' unless index >= 0
		raise 'line index out of bounds' unless index < @buffer.length

		@buffer[index]
	end

	def currentline
		getline @cursor.line
	end

	def lines
		@buffer.length
	end

	def cols
		@buffer[@cursor.line].length
	end
end
