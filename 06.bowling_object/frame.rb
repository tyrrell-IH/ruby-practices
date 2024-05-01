# frozen_string_literal: true

require_relative 'shot'
class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :frame_number
  attr_accessor :next_frame

  def initialize(frame_number:, first_record:, second_record: nil, third_record: nil)
    @frame_number = frame_number
    @first_shot = Shot.new(first_record)
    @second_shot = Shot.new(second_record) if second_record
    @third_shot = Shot.new(third_record) if third_record
  end

  def strike?
    return nil if @frame_number == 10

    @first_shot.score == 10
  end

  def spare?
    return nil if @frame_number == 10

    (@first_shot.score != 10) && ((@first_shot.score + @second_shot.score) == 10)
  end

  def score
    score = @first_shot.score
    score += @second_shot.score if @second_shot
    score += @third_shot.score if @third_shot
    score
  end
end
