#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# 列の幅が8の倍数になる
MULTIPLE_OF_COLUMN_WIDTH = 8

def main
  option = parse_options
  if ARGV.empty?
    text = $stdin.read
    puts generate_stdin_contents(text, option)
  else
    files = ARGV
    puts generate_contents(files, option)
    puts generate_total_contents(files, option) if files.size >= 2
  end
end

def parse_options
  params = {}
  opt = OptionParser.new
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!
  params = {l: true, w: true, c: true} if params.empty?
  params
end

def count_lines(file)
  File.read(file).lines.size
end

def count_words(file)
  words = File.read(file).split(/\s/)
  words.count { |word| !word.empty? }
end

def count_bytes(file)
  File.read(file).bytesize
end

def count_stdin_lines(text)
  text.lines.size
end

def count_stdin_words(text)
  words = text.split(/\s/)
  words.count { |word| !word.empty? }
end

def count_stdin_bytes(text)
  text.bytesize
end

def get_lines_width(files)
  max_file = files.max_by { |file| count_lines(file).to_s.length }
  max_length = count_lines(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_words_width(files)
  max_file = files.max_by { |file| count_words(file).to_s.length }
  max_length = count_words(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_bytes_width(files)
  max_file = files.max_by { |file| count_bytes(file).to_s }
  max_length = count_bytes(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_stdin_lines_width(text)
  length = count_stdin_lines(text).to_s.length
  (length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_stdin_words_width(text)
  length = count_stdin_words(text).to_s.length
  (length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_stdin_bytes_width(text)
  length = count_stdin_bytes(text).to_s.length
  (length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def generate_contents(files, option)
  lines_width = get_lines_width(files)
  words_width = get_words_width(files)
  bytes_width = get_bytes_width(files)
  contents = files.map do |file|
    content = []
    content << count_lines(file).to_s.rjust(lines_width) if option[:l]
    content << count_words(file).to_s.rjust(words_width) if option[:w]
    content << count_bytes(file).to_s.rjust(bytes_width) if option[:c]
    content << " #{file}"
    content.join('')
  end
  contents
end

def generate_total_contents(files, option)
  lines_width = get_lines_width(files)
  words_width = get_words_width(files)
  bytes_width = get_bytes_width(files)
  lines_total = files.inject(0) { |result, file| result + count_lines(file) }
  words_total = files.inject(0) { |result, file| result + count_words(file) }
  bytes_total = files.inject(0) { |result, file| result + count_bytes(file) }
  content = []
  content << lines_total.to_s.rjust(lines_width) if option[:l]
  content << words_total.to_s.rjust(words_width) if option[:w]
  content << bytes_total.to_s.rjust(bytes_width) if option[:c]
  content << ' total'
  content.join('')
end

def generate_stdin_contents(text, option)
  lines_width = get_stdin_lines_width(text)
  words_width = get_stdin_words_width(text)
  bytes_width = get_stdin_bytes_width(text)
  content = []
  content << count_stdin_lines(text).to_s.rjust(lines_width) if option[:l]
  content << count_stdin_words(text).to_s.rjust(words_width) if option[:w]
  content << count_stdin_bytes(text).to_s.rjust(bytes_width) if option[:c]
  content.join('')
end

main
