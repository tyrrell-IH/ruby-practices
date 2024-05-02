# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(records)
    @records = records
    @frames = []
  end

  def generate_frames
    separated_records = separate_records_by_frame
    separated_records.map do |records|
      @frames << if @frames.size == 9
                   Frame.new(first_record: records[0], second_record: records[1], third_record: records[2], last_frame: true)
                 else
                   Frame.new(first_record: records[0], second_record: records[1])
                 end
    end
    add_next_frame
  end

  def total_score
    normal_score + bonus_score
  end

  private

  def separate_records_by_frame
    separated_records = []
    until @records.empty?
      separated_records << if separated_records.size == 9
                             @records.shift(3)
                           elsif @records.first == 'X'
                             @records.shift(1)
                           else
                             @records.shift(2)
                           end
    end
    separated_records
  end

  def add_next_frame
    @frames.each_cons(2) do |frame, next_frame|
      frame.next_frame = next_frame
    end
  end
end

def normal_score
  @frames.inject(0) { |result, frame| result + frame.score }
end

def bonus_score
  bonus_score = 0
  @frames.each do |frame|
    next unless frame.strike? || frame.spare?

    bonus_score += frame.next_frame.first_shot.score
    next if frame.spare?

    bonus_score += if frame.next_frame.strike?
                     frame.next_frame.next_frame.first_shot.score
                   else
                     frame.next_frame.second_shot.score
                   end
  end
  bonus_score
end
