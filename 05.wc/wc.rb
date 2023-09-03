#! /usr/bin/env ruby
# frozen_string_literal: true

#列の幅が8の倍数になる
MULTIPLE_OF_COLUMN_WIDTH = 8

def count_lines(file)
  File.read(file).lines.size
end

def count_words(file)
  words = File.read(file).split(/\s/)
  words.reject{|word| word.length.zero?}.size
end

def count_bytes(file)
  File.read(file).bytesize
end

def get_lines_width(files)
  max_file = files.max_by { |file| count_lines(file).to_s.length}
  max_length = count_lines(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_words_width(files)
  max_file = files.max_by { |file| count_words(file).to_s.length}
  max_length = count_words(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_bytes_width(files)
  max_file = files.max_by { |file| count_bytes(file).to_s}
  max_length = count_bytes(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def generate_contents(files)
  lines_width = get_lines_width(files)
  words_width = get_words_width(files)
  bytes_width = get_bytes_width(files)
  contents = files.map do |file|
    [
    count_lines(file).to_s.rjust(lines_width),
    count_words(file).to_s.rjust(words_width),
    count_bytes(file).to_s.rjust(bytes_width),
    " #{file}"
  ].join('')
  end
end

def generate_total_contents(files)
  lines_width = get_lines_width(files)
  words_width = get_words_width(files)
  bytes_width = get_bytes_width(files)
  lines_total = files.inject(0) { |result, file| result + count_lines(file)}
  words_total = files.inject(0) { |result, file| result + count_words(file)}
  bytes_total = files.inject(0) { |result, file| result + count_bytes(file)}
  [
  lines_total.to_s.rjust(lines_width),
  words_total.to_s.rjust(words_width),
  bytes_total.to_s.rjust(bytes_width),
  " total"
].join('')
end

files = ARGV
puts generate_contents(files)
puts generate_total_contents(files)
