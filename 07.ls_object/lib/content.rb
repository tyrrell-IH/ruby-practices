# frozen_string_literal: true

class Content
  attr_reader :file_name
  def initialize(file_name)
    @file_name = file_name
  end
end
