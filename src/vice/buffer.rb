class Vice::Buffer
	attr_reader :filename
	attr_reader :buffer
	attr_accessor :cursor

	def initialize(filename, contents)
		@filename = filename if filename
		@buffer = if contents then contents else [""] end
		@cursor = Vice::Cursor.new
	end

	def newline(index)
		raise "negative line index" unless index >= 0

		# silently append to the end when index out of bounds
		index = @buffer.length if index > @buffer.length

		@buffer.insert index, ""
	end

	def rmline(index)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length

		@buffer.delete_at index
	end

	def insertf(index, column, text)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length
		raise "negative column index" unless column >= 0
		raise "column index out of bounds" unless column <= @buffer[index].length

		@buffer[index].insert column, text
	end

	def insert(text)
		insertf @cursor.line, @cursor.col, text
	end

	def setline(index, text)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length

		@buffer[index] = text
	end

	def getline(index)
		raise "negative line index" unless index >= 0
		raise "line index out of bounds" unless index < @buffer.length

		return @buffer[index]
	end

	def lines
		return @buffer.length 
	end

	def cols
		return @buffer[@cursor.line].length
	end
end
