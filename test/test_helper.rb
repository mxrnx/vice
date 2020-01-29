# frozen_string_literal: true

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'test/'
end

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'

Dir.foreach('test/') do |test|
	next if ['.', '..'].include? test

	require_relative test
end

Dir.foreach('test/vice') do |test|
	next if ['.', '..'].include? test

	require_relative 'vice/' + test
end
