class Vice::Prompt
	def self.parse(vice, line, buffer)
		words = line.split ' '
		return if words.length == 0

		case words[0]
		when 'e'
			if words.length > 1
				files = words.dup
				files.shift
				files.each do |f|
					vice.buffers.push Vice::Buffer.new(f)
				end
			else
				# TODO: notify user of user error
			end
		when 'w'
			if words.length > 1
				buffer.write words[1]
			elsif buffer.filename != nil
				buffer.write
			else
				# TODO: notify user of user error
			end
		when 'q'
			vice.buffers.delete buffer
			exit if vice.buffers.empty?
		end
	end
end
