task default: %w[run]

task :run do
	require_relative 'lib/vice'
	Vice::Vice.new(nil).start
end

task :test do
	ruby 'test/test_helper.rb'
end

task :style do
	sh 'rubocop -c .rubocop.yml lib/ test/ Gemfile Rakefile vice-editor.gemspec'
end
