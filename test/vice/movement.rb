require "minitest/autorun"

require_relative "../../src/vice"

class TestMovement < MiniTest::Test
	def test_w_end_of_string
		assert_equal Vice::Movement.w("abc", 0), 2
	end

	def test_w_some_words
		assert_equal Vice::Movement.w("jantje zag eens", 2), 7
	end

	def test_w_with_other_whitespace_chars
		assert_equal Vice::Movement.w("jantje\t\nzag eens", 2), 8
	end

	def test_b_start_of_string
		assert_equal Vice::Movement.b("aaaaa", 5), 0
	end

	def test_b_some_words
		assert_equal Vice::Movement.b("ab cd", 4), 3
	end

	def test_b_from_start_of_word
		assert_equal Vice::Movement.b("jantje zag eens", 11), 7
	end

	def test_w_W_difference
		string = "aaa-bbb ccc"
		assert_equal Vice::Movement.w(string, 1), 4
		assert_equal Vice::Movement.W(string, 1), 8
	end

	def test_b_B_difference
		string = "bbb-ccc"
		assert_equal Vice::Movement.b(string, 5), 4
		assert_equal Vice::Movement.B(string, 5), 0
	end
end
