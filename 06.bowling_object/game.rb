# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(records)
    @records = records
    @frames = []
  end

  def generate_frames
    separated_records = separate_records_by_frame
    separated_records.map.with_index(1) do |records, i|
      @frames << case records.size
                 when 1
                   Frame.new(frame_number: i, first_record: records[0])
                 when 2
                   Frame.new(frame_number: i, first_record: records[0], second_record: records[1])
                 when 3
                   Frame.new(frame_number: i, first_record: records[0], second_record: records[1], third_record: records[2])
                 end
    end
    add_next_frame
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
