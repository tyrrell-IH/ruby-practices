# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(record)
    @score = if record == 'X'
               10
             else
               record.to_i
             end
  end
end
