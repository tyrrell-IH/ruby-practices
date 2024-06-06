#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/display'

file_names = Dir.glob('*')
Display.new(file_names).exec
