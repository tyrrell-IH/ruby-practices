# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :frame_number

  def initialize(frame_number:, first_shot:, second_shot: nil, third_shot: nil)
    @frame_number = frame_number
    @first_shot = first_shot
    @second_shot = second_shot if second_shot
    @third_shot = third_shot if third_shot
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    (@first_shot.score != 10) && ((@first_shot.score + @second_shot.score) == 10)
  end

  def score
    normal_score + bonus_score
  end

  private

  def normal_score
    score = @first_shot.score
    score += @second_shot.score if @second_shot
    score += @third_shot.score if @third_shot
    score
  end

  def bonus_score
    return 0 if @frame_number == 10

    if strike?
      @first_shot.next_shot.score + @first_shot.next_shot.next_shot.score
    elsif spare?
      @second_shot.next_shot.score
    else
      0
    end
  end
end
