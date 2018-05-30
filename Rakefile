task default: %w[run]

task :run do
	ruby "src/main.rb"
end

task :test do
	Dir.foreach("test/vice") do |test|
		next if test == "." or test == ".."
		ruby "test/vice/" + test
	end
end
