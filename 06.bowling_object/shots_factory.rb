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
    add_next_shot(shots)
    shots
  end

  private

  def add_next_shot(shots)
    shots.each_cons(2) do |shot, next_shot|
      shot.next_shot = next_shot
    end
  end
end
