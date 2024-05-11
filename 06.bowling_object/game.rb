# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(records)
    @records = records
    @frames = []
  end

  def result
    generate_frames
    total_score
  end

  private

  def generate_frames
    until @records.empty?
      @frames << if @frames.size == 9
                   record1, record2, record3 = @records.shift(3)
                   Frame.new(first_record: record1, second_record: record2, third_record: record3, last_frame: true)
                 elsif @records.first == 'X'
                   record = @records.shift(1)
                   Frame.new(first_record: record[0])
                 else
                   record1, record2 = @records.shift(2)
                   Frame.new(first_record: record1, second_record: record2)
                 end
    end
    add_next_frame
  end

  def add_next_frame
    @frames.each_cons(2) do |frame, next_frame|
      frame.next_frame = next_frame
    end
  end
end

def total_score
  normal_score + bonus_score
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
