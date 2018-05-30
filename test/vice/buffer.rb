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

	def test_newline_normal
		@buffer.newline 0
		assert_equal [""], @buffer.buffer
	end

	def test_newline_negative_index
		assert_raises RuntimeError do
			@buffer.newline -1
		end
	end

	def test_insert_normal
		@buffer.newline 0
		assert_equal [""], @buffer.buffer

		@buffer.insert 0, 0, "chunky bacon"
		assert_equal "chunky bacon", @buffer.buffer[0]

		@buffer.insert 0, 6, " crispy"
		assert_equal "chunky crispy bacon", @buffer.buffer[0]
	end
end
