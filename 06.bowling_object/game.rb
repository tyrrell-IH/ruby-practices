# frozen_string_literal: true

require_relative 'frame'
require_relative 'score_arrangement'

class Game
  include ScoreArrangement

  attr_reader :total_score

  def initialize(scores)
    @frames = []
    scores_each_frames = arrange_scores(scores)
    scores_each_frames.map.with_index(1) do |frame_score, n|
      @frames << case frame_score.size
                 when 1
                   Frame.new(frame_number: n, first_shot: frame_score[0])
                 when 2
                   Frame.new(frame_number: n, first_shot: frame_score[0], second_shot: frame_score[1])
                 when 3
                   Frame.new(frame_number: n, first_shot: frame_score[0], second_shot: frame_score[1], third_shot: frame_score[2])
                 end
    end
  end
end
