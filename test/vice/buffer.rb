require "minitest/autorun"

require_relative "../../src/vice"

class TestBuffer < MiniTest::Test
	def setup
		@buffer = Vice::Buffer.new nil
	end

	def test_create_buffer
		assert_equal [""], @buffer.buffer
	end

	def test_newline_valid
		@buffer.newline 0
		assert_equal ["", ""], @buffer.buffer
	end

	def test_newline_negative_index
		assert_raises RuntimeError do
			@buffer.newline -1
		end
	end

	def test_insert_and_insertf_valid
		@buffer.insert "chunky bacon"
		assert_equal "chunky bacon", @buffer.buffer[0]

		@buffer.insertf 0, 6, " crispy"
		assert_equal "chunky crispy bacon", @buffer.buffer[0]
	end

	def test_insertf_out_of_bounds
		# negative line index
		assert_raises RuntimeError do
			@buffer.insertf -1, 0, ""
		end

		# out of bounds line index
		assert_raises RuntimeError do
			@buffer.insertf 2, 0, ""
		end

		@buffer.newline 0

		# negative column index
		assert_raises RuntimeError do
			@buffer.insertf 0, -1, ""
		end

		# out of bounds column index
		assert_raises RuntimeError do
			@buffer.insertf 0, 2, ""
		end
	end

	def test_setline_valid
		assert_equal [""], @buffer.buffer

		@buffer.setline 0, "chunky bacon"
		assert_equal "chunky bacon", @buffer.buffer[0]
	end

	def test_rmlinef_valid
		assert_equal [""], @buffer.buffer

		@buffer.rmlinef 0
		assert_equal [], @buffer.buffer
	end

	def test_getline_valid
		@buffer.setline 0, "chunky bacon"
		assert_equal @buffer.getline(0), "chunky bacon"
	end
end
