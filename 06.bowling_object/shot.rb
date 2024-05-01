# frozen_string_literal: true

class Shot
  attr_reader :score
  attr_accessor :next_score, :next_next_score

  def initialize(score)
    @score = score == 'X' ? 10 : score.to_i
  end
end
