require 'minitest/autorun'

require_relative '../src/vice'

class TestVice < MiniTest::Test
	def setup
		@vice = Vice::Vice.new
		@vice.buffers.push Vice::Buffer.new nil
		@vice.buffers.push Vice::Buffer.new nil
	end

	def test_switch_tab_forward
		assert_equal 0, @vice.current_buffer

		@vice.next_buffer
		assert_equal 1, @vice.current_buffer

		@vice.next_buffer
		assert_equal 2, @vice.current_buffer

		@vice.next_buffer
		assert_equal 0, @vice.current_buffer
	end

	def test_switch_tab_backward
		assert_equal 0, @vice.current_buffer

		@vice.prev_buffer
		assert_equal 2, @vice.current_buffer

		@vice.prev_buffer
		assert_equal 1, @vice.current_buffer

		@vice.prev_buffer
		assert_equal 0, @vice.current_buffer
	end
end
