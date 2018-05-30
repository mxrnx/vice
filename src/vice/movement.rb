class Vice::Movement
	def self.whitespace(char, harsh)
		if harsh # only real whitespace
			return (char == ' ' || char == "\t" || char == "\n")
		else # anything that's not alphanumeric
			return !(char =~ /\A\p{Alnum}+\z/)
		end
	end

	def self.w_real(line, start, harsh)
		return start if start == line.length - 1
		return start + 1 if whitespace(line[start], harsh) && !whitespace(line[start + 1], harsh)
		return w_real(line, start + 1, harsh)
	end

	def self.w(line, start)
		w_real(line, start, false)
	end

	def self.W(line, start)
		w_real(line, start, true)
	end

	def self.b_internal(line, start, harsh)
		return start if start == 0
		return start if !whitespace(line[start], harsh) && whitespace(line[start - 1], harsh)
		return b_internal(line, start - 1, harsh)
	end

	def self.b_real(line, start, harsh)
		# if we're already on the beginning of a word, we want to jump to the previous one
		if start > 0 && !whitespace(line[start], harsh) && whitespace(line[start - 1], harsh)
			start -= 1
		end

		return b_internal(line, start, harsh)
	end
	def self.b(line, start)
		b_real(line, start, false)
	end

	def self.B(line, start)
		b_real(line, start, true)
	end
end
