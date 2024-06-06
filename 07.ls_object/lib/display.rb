# frozen_string_literal: true

require_relative 'format'

class Display
  def initialize(file_names)
    @file_names = file_names
  end

  def exec
    puts Format.new(@file_names).adjust
  end
end
