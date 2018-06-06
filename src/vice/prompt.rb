class Vice::Prompt
	def self.parse(vice, line, buffer)
		words = line.split ' '
		return if words.empty?

		case words[0]
		when 'e'
			if words.length > 1
				files = words.dup
				files.shift
				vice.buffers.delete buffer unless buffer.modified
				files.each do |f|
					vice.buffers.push Vice::Buffer.new(f)
				end
			else
				vice.error 'no such file'
			end
		when 'w'
			if words.length > 1
				buffer.writef words[1]
			elsif !buffer.filename.nil?
				buffer.write
			else
				vice.error 'buffer has no filename'
			end
		when 'q'
			vice.buffers.delete buffer
			exit if vice.buffers.empty?
		end
	end
end
