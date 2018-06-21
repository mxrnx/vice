module Vice
	DEFAULTS = {
		tab_width:	4,
		keys:		{
			'j' => :down,
			'k' => :up,
			'l' => :right,
			'h' => :left,

			'w' => :word,
			'W' => :word_large,
			'b' => :backword,
			'B' => :backword_large,

			'$' => :endline,
			'0' => :beginline,

			'i' => :insert_before,
			'a' => :insert_after,
			'I' => :insert_begin,
			'A' => :insert_end,
			'O' => :insert_before_line,
			'o' => :insert_after_line,

			'X' => :remove_before,
			'x' => :remove_after,

			'cw' => :change_word,
			'cc' => :change_line,
			'dw' => :delete_word,
			'dd' => :delete_line,

			'g' => :jump_start,
			'G' => :jump_end,

			'm' => :mark_set,
			"'" => :mark_jump,

			't' => :buffer_next,
			'T' => :buffer_prev,

			';' => :mode_prompt
		}
	}.freeze
end
