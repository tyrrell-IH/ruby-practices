#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/multi_column_format'
require_relative '../lib/long_format'
require 'optparse'

params = {}
opt = OptionParser.new
opt.on('-a') { |v| params[:a] = v }
opt.on('-r') { |v| params[:r] = v }
opt.on('-l') { |v| params[:l] = v }
opt.parse!

file_names = params[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
file_names.reverse! if params[:r]
if params[:l]
  puts LongFormat.new(file_names).fit_in
else
  puts MultiColumnFormat.new(file_names).fit_in
end
