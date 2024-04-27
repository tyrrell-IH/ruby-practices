# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :frame_number

  def initialize(frame_number:, first_shot:, second_shot:, third_shot: nil)
    @frame_number = frame_number
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
    @strike = false
    @spare = false

    if @first_shot.score == 10
      @strike = true
    elsif (@first_shot.score + @second_shot.score) == 10
      @spare = true
    end
  end

  def strike?
    @strike
  end

  def spare?
    @spare
  end

  def score
    frame_score = @first_shot.score + @second_shot.score
    @third_shot ? (frame_score + @third_shot.score) : frame_score
  end
end
