#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/multi_column_format'
require_relative '../lib/long_format'
require_relative '../lib/option'

file_names = Option.a? ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
file_names.reverse! if Option.r?
if Option.l?
  puts LongFormat.new(file_names).fit_in
else
  puts MultiColumnFormat.new(file_names).fit_in
end
