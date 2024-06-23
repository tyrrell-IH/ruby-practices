#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/multi_column_format'
require_relative '../lib/long_format'
require 'optparse'

def main
  options = parse_options
  file_names = Dir.glob('*', options[:a] ? File::FNM_DOTMATCH : 0)
  file_names.reverse! if options[:r]
  choose_format(file_names, long_format: options[:l])
end

def parse_options
  params = {}
  opt = OptionParser.new
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse!
  params
end

def choose_format(file_names, long_format:)
  format_class = long_format ? LongFormat : MultiColumnFormat
  puts format_class.new(file_names).fit_in
end

main
