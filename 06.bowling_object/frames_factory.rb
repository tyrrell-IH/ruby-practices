# frozen_string_literal: true

require_relative 'frame'

class FramesFactory
  attr_reader :frames

  def initialize(scores)
    arranged_scores = arrange_scores(scores)
    @frames = make_frames(arranged_scores)
  end

  private

  def arrange_scores(scores)
    scores_each_frame = []
    until scores.empty?
      scores_each_frame << if scores_each_frame.size == 9
                             scores.shift(3)
                           elsif scores.first == 'X'
                             scores.shift(1)
                           else
                             scores.shift(2)
                           end
    end
    scores_each_frame
  end

  def make_frames(arranged_scores)
    frames = []
    arranged_scores.map.with_index(1) do |frame_score, n|
      frames << case frame_score.size
                when 1
                  Frame.new(frame_number: n, first_shot: frame_score[0])
                when 2
                  Frame.new(frame_number: n, first_shot: frame_score[0], second_shot: frame_score[1])
                when 3
                  Frame.new(frame_number: n, first_shot: frame_score[0], second_shot: frame_score[1], third_shot: frame_score[2])
                end
    end

    frames.each_cons(2) do |frame, next_frame|
      frame.next_frame = next_frame
    end
    frames
  end
end
