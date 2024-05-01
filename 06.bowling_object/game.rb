# frozen_string_literal: true

require_relative 'frames_factory'

class Game
  def initialize(scores)
    @frames = FramesFactory.new(scores).manufacture
  end

  def total_score
    @frames.inject(0) { |result, frame| result + frame.score }
  end
end
