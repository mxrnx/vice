task default: %w[run]

task :run do
	require_relative 'lib/vice'
	Vice::Vice.new(nil).start
end

task :test do
	Dir.foreach('test/vice') do |test|
		next if ['.', '..'].include? test
		ruby 'test/vice/' + test
	end
	ruby 'test/vice.rb'
end

task :style do
	sh 'rubocop -c .rubocop.yml lib/ test/ Gemfile Rakefile vice-editor.gemspec'
end
