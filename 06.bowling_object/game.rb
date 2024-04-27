# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :total_score

  def initialize(scores)
    @total_score = 0
    scores.each_slice(2).with_index(1) do |frame_score, n|
      @total_score += Frame.new(first_shot: Shot.new(frame_score[0]), second_shot: Shot.new(frame_score[1]), frame_number: n).score
    end
  end
end
