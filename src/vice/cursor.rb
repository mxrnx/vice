class Vice::Cursor
	attr_accessor :line, :col

	def initialize(line = 0, col = 0)
		@line = line
		@col = col
	end
end
