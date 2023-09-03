#! /usr/bin/env ruby
# frozen_string_literal: true

#列の幅が8の倍数になる
MULTIPLE_OF_COLUMN_WIDTH = 8

def count_lines(file)
  File.read(file).lines.size.to_s
end

def count_words(file)
  words = File.read(file).split(/\s/)
  words.reject{|word| word.length.zero?}.size.to_s
end

def count_bytes(file)
  File.read(file).bytesize.to_s
end

def get_lines_width(files)
  max_file = files.max_by { |file| count_lines(file)}
  max_length = count_lines(max_file).length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_words_width(files)
  max_file = files.max_by { |file| count_words(file)}
  max_length = count_words(max_file).length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_bytes_width(files)
  max_file = files.max_by { |file| count_bytes(file)}
  max_length = count_bytes(max_file).length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def generate_contents(files)
  lines_width = get_lines_width(files)
  words_width = get_words_width(files)
  bytes_width = get_bytes_width(files)
  contents = files.map do |file|
    [
      count_lines(file).rjust(lines_width),
      count_words(file).rjust(words_width),
      count_bytes(file).rjust(bytes_width),
      " #{file}"
  ]
  end
end
