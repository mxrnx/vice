class Vice::Buffer
	attr_reader :filename
	attr_reader :buffer

	def initialize(filename, contents)
		@filename = filename if filename
		@buffer = if contents then contents else Array.new end
	end

	def newline(index)
		raise "Negative line index" unless index >= 0

		# silently append to the end when index out of bounds
		index = @buffer.length if index > @buffer.length

		@buffer.insert index, ""
	end

	def rmline(index)
		raise "Negative line index" unless index >= 0
		raise "Line index out of bounds" unless index < @buffer.length

		@buffer.delete_at index
	end

	def insert(index, column, text)
		raise "Negative line index" unless index >= 0
		raise "Line index out of bounds" unless index < @buffer.length
		raise "Negative column index" unless column >= 0
		raise "Column index out of bounds" unless column <= @buffer[index].length

		@buffer[index].insert column, text
	end

	def setline(index, text)
		raise "Negative line index" unless index >= 0
		raise "Line index out of bounds" unless index < @buffer.length

		@buffer[index] = text
	end
end
