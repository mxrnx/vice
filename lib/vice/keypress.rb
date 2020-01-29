class Vice::KeyPress
	def self.down(_vice, buffer)
		buffer.cursor_down
	end

	def self.up(_vice, buffer)
		buffer.cursor_up
	end

	def self.right(_vice, buffer)
		buffer.cursor_right
	end

	def self.left(_vice, buffer)
		buffer.cursor_left
	end

	def self.word(_vice, buffer)
		buffer.cursor.col = Vice::Movement.w(buffer.currentline, buffer.cursor.col)
	end

	def self.word_large(_vice, buffer)
		buffer.cursor.col = Vice::Movement.w_large(buffer.currentline, buffer.cursor.col)
	end

	def self.backword(_vice, buffer)
		buffer.cursor.col = Vice::Movement.b(buffer.currentline, buffer.cursor.col)
	end

	def self.backword_large(_vice, buffer)
		buffer.cursor.col = Vice::Movement.b_large(buffer.currentline, buffer.cursor.col)
	end

	def self.endline(_vice, buffer)
		buffer.cursor.col = Vice::Movement.dollar buffer.currentline
	end

	def self.beginline(_vice, buffer)
		buffer.cursor.col = Vice::Movement.zero
	end

	def self.insert_before(vice, _buffer)
		vice.mode = :insert
	end

	def self.insert_after(vice, buffer)
		buffer.cursor.col += 1 if buffer.cursor.col < buffer.cols
		vice.mode = :insert
	end

	def self.insert_begin(vice, buffer)
		buffer.cursor.col = 0
		vice.mode = :insert
	end

	def self.insert_end(vice, buffer)
		buffer.cursor.col = buffer.cols
		vice.mode = :insert
	end

	def self.insert_before_line(vice, buffer)
		buffer.newline buffer.cursor.line
		buffer.cursor.col = 0
		vice.mode = :insert
	end

	def self.insert_after_line(vice, buffer)
		buffer.newline buffer.cursor.line + 1
		buffer.cursor_down
		vice.mode = :insert
	end

	def self.remove_before(_vice, _buffer)
			# TODO
	end

	def self.remove_after(_vice, buffer)
		buffer.rmchar
		buffer.cursor.col -= 1 if buffer.cursor.col.positive?
	end

	def self.change_word(vice, buffer)
		delete_word(vice, buffer)
		vice.mode = :insert
	end

	def self.change_line(vice, buffer)
		buffer.setline buffer.cursor.line, ''
		buffer.cursor.col = 0
		vice.mode = :insert
	end

	def self.delete_word(_vice, buffer)
		line_edited = buffer.currentline
		slice_start = buffer.cursor.col
		slice_end = Vice::Movement.w(buffer.currentline, buffer.cursor.col)
		amount = slice_end - buffer.cursor.col
		amount += 1 if slice_end == buffer.currentline.length - 1
		line_edited.slice! slice_start, amount

		buffer.setline buffer.cursor.line, line_edited
	end

	def self.delete_line(_vice, buffer)
		if buffer.lines == 1
			buffer.setline 0, ''
		else
			buffer.rmline
		end
		buffer.cursor.line -= 1 if buffer.lines <= buffer.cursor.line
		buffer.cursor.col = 0
	end

	def self.jump_start(_vice, buffer)
		buffer.cursor.line = 0
		buffer.cursor.col = 0
	end

	def self.jump_end(_vice, buffer)
		buffer.cursor.line = buffer.lines - 1
		buffer.cursor.col = 0
	end

	def self.mark_set(vice, buffer, char)
		if buffer.hasmark char
			vice.alert "replaced mark '" + char + "'"
		else
			vice.alert "added mark '" + char + "'"
		end
		buffer.addmark char
	end

	def self.mark_jump(vice, buffer, char)
		vice.alert 'mark not set' unless buffer.gotomark char
	end

	def self.buffer_next(vice, _buffer)
		vice.next_buffer
		@trail = []
	end

	def self.buffer_prev(vice, _buffer)
		vice.prev_buffer
		@trail = []
	end

	def self.mode_prompt(vice, _buffer)
		vice.mode = :prompt
	end
end
