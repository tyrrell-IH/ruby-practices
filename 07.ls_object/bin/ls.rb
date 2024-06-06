#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/display'
require_relative '../lib/option'

file_names = Option.has_a? ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
file_names.reverse! if Option.has_r?
Display.new(file_names).exec
