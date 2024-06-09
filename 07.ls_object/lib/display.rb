# frozen_string_literal: true

require_relative 'normal_format'
require_relative 'long_format'
require_relative 'option'

class Display
  def initialize(file_names)
    @file_names = file_names
  end

  def exec
    if Option.l?
      puts LongFormat.new(@file_names).adjust
    else
      puts NormalFormat.new(@file_names).adjust
    end
  end
end
