require "minitest/autorun"

require_relative "../../src/vice"
require_relative "../../src/vice/buffer"

class TestBuffer < MiniTest::Test
	def setup
		@buffer = Vice::Buffer.new(nil, nil)
	end

	def test_create_buffer
		assert_equal Array.new, @buffer.buffer
	end

	def test_newline_valid
		@buffer.newline 0
		assert_equal [""], @buffer.buffer
	end

	def test_newline_negative_index
		assert_raises RuntimeError do
			@buffer.newline -1
		end
	end

	def test_insert_valid
		@buffer.newline 0
		assert_equal [""], @buffer.buffer

		@buffer.insert 0, 0, "chunky bacon"
		assert_equal "chunky bacon", @buffer.buffer[0]

		@buffer.insert 0, 6, " crispy"
		assert_equal "chunky crispy bacon", @buffer.buffer[0]
	end

	def test_insert_out_of_bounds
		# negative line index
		assert_raises RuntimeError do
			@buffer.insert -1, 0, ""
		end

		# out of bounds line index
		assert_raises RuntimeError do
			@buffer.insert 2, 0, ""
		end

		@buffer.newline 0

		# negative column index
		assert_raises RuntimeError do
			@buffer.insert 0, -1, ""
		end

		# out of bounds column index
		assert_raises RuntimeError do
			@buffer.insert 0, 2, ""
		end
	end

	def test_setline_valid
		@buffer.newline 0
		assert_equal [""], @buffer.buffer

		@buffer.setline 0, "chunky bacon"
		assert_equal "chunky bacon", @buffer.buffer[0]
	end

	def test_rmline_valid
		@buffer.newline 0
		assert_equal [""], @buffer.buffer

		@buffer.rmline 0
		assert_equal [], @buffer.buffer
	end

	def test_getline_valid
		@buffer.newline 0
		@buffer.setline 0, "chunky bacon"
		assert_equal @buffer.getline 0, "chunky bacon"
	end
end
