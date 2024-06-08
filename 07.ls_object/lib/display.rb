# frozen_string_literal: true

require_relative 'format'
require_relative 'long_format'
require_relative 'option'

class Display
  def initialize(file_names)
    @file_names = file_names
  end

  def exec
    puts Option.l? ? LongFormat.new(@file_names).adjust : Format.new(@file_names).adjust
  end
end
