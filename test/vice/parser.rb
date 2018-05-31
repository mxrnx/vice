require "minitest/autorun"

require_relative "../../src/vice"

class TestParser < MiniTest::Test
	def setup
		@vice = Vice::Vice.new
		@vice.buffers.push Vice::Buffer.new nil
		@parser = Vice::Parser.new
		@buffer = 0
	end

	def test_parsechar_command_movement_up_down
		@vice.buffers[@buffer].newline 0
		assert_equal @vice.buffers[@buffer].cursor.line, 0

		# go down one line
		@parser.parsechar_command @vice, @buffer, 'j'
		assert_equal @vice.buffers[@buffer].cursor.line, 1

		# don't go down another line if no more lines exist
		@parser.parsechar_command @vice, @buffer, 'j'
		assert_equal @vice.buffers[@buffer].cursor.line, 1
		
		# go up one line
		@parser.parsechar_command @vice, @buffer, 'k'
		assert_equal @vice.buffers[@buffer].cursor.line, 0
		
		# don't go up another line if no more lines exist
		@parser.parsechar_command @vice, @buffer, 'k'
		assert_equal @vice.buffers[@buffer].cursor.line, 0
	end

	# test that we enter insert mode after pressing i
	def test_parsechar_command_i
		assert_equal @vice.mode, :command

		@parser.parsechar_command @vice, @buffer, 'i'
		assert_equal @vice.mode, :insert
	end

	# test the I command
	def test_parsechar_command_I
		@vice.buffers[@buffer].setline 0, "abcdefg"
		@vice.buffers[@buffer].cursor.col = 4

		@parser.parsechar_command @vice, @buffer, 'I'
		assert_equal @vice.mode, :insert
		assert_equal @vice.buffers[@buffer].cursor.col, 0
	end

	# test inserting characters
	def test_insert_some_text
		@vice.mode = :insert
		@parser.parsechar_insert @vice, @buffer, 'h'
		@parser.parsechar_insert @vice, @buffer, 'e'
		@parser.parsechar_insert @vice, @buffer, 'y'
		assert_equal @vice.buffers[@buffer].getline(0), "hey"
	end

	# test inserting characters in a more random place
	def test_parsechar_insert_in_the_middle
		@vice.mode = :insert
		@vice.buffers[@buffer].newline 0
		@vice.buffers[@buffer].newline 0
		@vice.buffers[@buffer].setline 1, "é melhorser alegre que ser triste"
		assert_equal @vice.buffers[@buffer].buffer, ["", "é melhorser alegre que ser triste", ""]

		@vice.buffers[@buffer].cursor.line = 1
		@vice.buffers[@buffer].cursor.col = 8
		@parser.parsechar_insert @vice, @buffer, ' '
		assert_equal @vice.buffers[@buffer].getline(1), "é melhor ser alegre que ser triste"
	end

	def test_parsechar_insert_escape
		@vice.mode = :insert

		@parser.parsechar_insert @vice, @buffer, 27
		assert_equal @vice.mode, :command
	end
end
