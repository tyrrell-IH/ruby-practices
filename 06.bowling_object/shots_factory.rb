# frozen_string_literal: true

require_relative 'shot'

class ShotsFactory
  def initialize(scores)
    @scores = scores
  end

  def manufacture
    shots = @scores.map do |score|
      Shot.new(score)
    end
    add_next_score(shots)
    shots
  end

  private

  def add_next_score(shots)
    shots.each_cons(3) do |shot, next_shot, next_next_shot|
      shot.next_score = next_shot.score
      shot.next_next_score = next_next_shot.score
    end
  end
end
