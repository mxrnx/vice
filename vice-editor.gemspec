require 'rake'
require_relative 'lib/vice/version'

Gem::Specification.new do |s|
	s.name = 'vice-editor'
	s.version = Vice::VERSION
	s.platform = Gem::Platform::RUBY
	s.license = 'GPL-3.0'
	s.has_rdoc = false
	s.summary = 'vi-like text editor'
	s.author = 'knarka'
	s.email = 'knarka@airmail.cc'
	s.homepage = 'https://github.com/knarka/vice'
	s.executables = ['vice']

	s.add_dependency 'curses', '= 1.2.4'
	s.required_ruby_version = '>= 2.3.3'

	s.files = %w(LICENSE README.md) +
		Dir.glob('{bin,lib}/**/*')

	s.require_path = 'lib'
	s.bindir = 'bin'
end
