class Vice::Movement
	def self.whitespace(char, harsh)
		if harsh # only real whitespace
			(char == ' ' || char == "\t" || char == "\n")
		else # anything that's not alphanumeric
			char !~ /\A\p{Alnum}+\z/
		end
	end

	def self.w_real(line, start, harsh)
		return start if start == line.length - 1
		return start + 1 if whitespace(line[start], harsh) && !whitespace(line[start + 1], harsh)
		w_real(line, start + 1, harsh)
	end

	def self.w(line, start)
		w_real(line, start, false)
	end

	def self.w_large(line, start)
		w_real(line, start, true)
	end

	def self.b_internal(line, start, harsh)
		return start if start.zero?

		return start if !whitespace(line[start], harsh) && whitespace(line[start - 1], harsh)

		b_internal(line, start - 1, harsh)
	end

	def self.b_real(line, start, harsh)
		# if we're already on the beginning of a word, we jump to the previous one
		start -= 1 if start > 0 && !whitespace(line[start], harsh) && whitespace(line[start - 1], harsh)

		b_internal(line, start, harsh)
	end

	def self.b(line, start)
		b_real(line, start, false)
	end

	def self.b_large(line, start)
		b_real(line, start, true)
	end

	def self.dollar(line)
		line.length - 1
	end

	def self.zero
		0
	end
end
