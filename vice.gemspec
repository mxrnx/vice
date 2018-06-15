require 'rake'
require_relative 'lib/vice/version'

Gem::Specification.new do |s|
	s.name = 'vice'
	s.version = Vice::VERSION
	s.platform = Gem::Platform::RUBY
	s.has_rdoc = false
	s.summary = 'vi-like text editor'
	s.author = 'knarka'
	s.email = 'knarka@users.noreply.github.com'
	s.homepage = 'https://github.com/knarka/vice'
	s.executables = ['vice']

	s.add_dependency('curses')
	s.add_dependency('rake')
	s.required_ruby_version = '>= 2.3.3'

	s.files = %w(README.md Rakefile) +
		Dir.glob('{bin,test,lib}/**/*')

	s.require_path = 'lib'
	s.bindir = 'bin'
end
