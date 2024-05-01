# frozen_string_literal: true

require_relative 'frame'
require_relative 'shots_factory'

class FramesFactory
  def initialize(scores)
    @shots = ShotsFactory.new(scores).manufacture
    @shots_each_frame = []
  end

  def manufacture
    separate_by_frame

    frames = []
    @shots_each_frame.map.with_index(1) do |frame, n|
      frames << case frame.size
                when 1
                  Frame.new(frame_number: n, first_shot: frame[0])
                when 2
                  Frame.new(frame_number: n, first_shot: frame[0], second_shot: frame[1])
                when 3
                  Frame.new(frame_number: n, first_shot: frame[0], second_shot: frame[1], third_shot: frame[2])
                end
    end
    frames
  end

  private

  def separate_by_frame
    until @shots.empty?
      @shots_each_frame << if @shots_each_frame.size == 9
                             @shots.shift(3)
                           elsif @shots.first.score == 10
                             @shots.shift(1)
                           else
                             @shots.shift(2)
                           end
    end
    @shots_each_frame
  end
end
