# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :frame_number

  def initialize(frame_number:, first_shot:, second_shot: nil, third_shot: nil)
    @frame_number = frame_number
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot) if second_shot
    @third_shot = Shot.new(third_shot) if third_shot
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    (@first_shot.score != 10) && ((@first_shot.score + @second_shot.score) == 10)
  end

  def score
    frame_score = @first_shot.score + @second_shot.score
    @third_shot ? (frame_score + @third_shot.score) : frame_score
  end
end
