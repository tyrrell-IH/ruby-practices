# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot
  attr_accessor :next_frame

  def initialize(first_record:, second_record: nil, third_record: nil, last_frame: false)
    @first_shot = Shot.new(first_record)
    @second_shot = Shot.new(second_record) if second_record
    @third_shot = Shot.new(third_record) if third_record
    @last_frame = last_frame
  end

  def last_frame?
    @last_frame
  end

  def strike?
    return nil if last_frame?

    @first_shot.score == 10
  end

  def spare?
    return nil if last_frame?

    (@first_shot.score != 10) && ((@first_shot.score + @second_shot.score) == 10)
  end

  def score
    score = @first_shot.score
    score += @second_shot.score if @second_shot
    score += @third_shot.score if @third_shot
    score
  end
end
