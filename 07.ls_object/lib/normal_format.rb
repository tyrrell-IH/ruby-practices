# frozen_string_literal: true

class NormalFormat
  NUMBER_OF_COLUMNS = 3
  MULTIPLE_OF_COLUMN_WIDTH = 8

  def initialize(file_names)
    @file_names = file_names
  end

  def adjust
    column_width = calc_column_width
    sorted_files = sort_files_by_columns
    sorted_files.map do |one_line_files|
      one_line_files.map { |file| file.ljust(column_width) }.join('')
    end
  end

  private

  def sort_files_by_columns
    file_names = @file_names
    file_names << '' while file_names.size % NUMBER_OF_COLUMNS != 0
    lines_number = file_names.size / NUMBER_OF_COLUMNS
    file_names.each_slice(lines_number).to_a.transpose
  end

  def calc_column_width
    max_of_length = @file_names.max_by(&:length).length
    (max_of_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
  end
end
