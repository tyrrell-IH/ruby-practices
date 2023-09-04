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
    puts generate_args_contents(files, option)
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
  params = { l: true, w: true, c: true } if params.empty?
  params
end

def count_arg_lines(file)
  File.read(file).lines.size
end

def count_arg_words(file)
  words = File.read(file).split(/\s/)
  words.count { |word| !word.empty? }
end

def count_arg_bytes(file)
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

# 行数、単語数、バイト数の各文字数の最大値より大きく、かつ8の倍数の内で最小の数を列の幅とする。
def get_arg_lines_width(files)
  max_file = files.max_by { |file| count_arg_lines(file).to_s.length }
  max_length = count_arg_lines(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_arg_words_width(files)
  max_file = files.max_by { |file| count_arg_words(file).to_s.length }
  max_length = count_arg_words(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_arg_bytes_width(files)
  max_file = files.max_by { |file| count_arg_bytes(file).to_s }
  max_length = count_arg_bytes(max_file).to_s.length
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def collect_arg_width(files)
  {
    lines: get_arg_lines_width(files),
    words: get_arg_words_width(files),
    bytes: get_arg_bytes_width(files)
  }
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

def collect_stdin_width(text)
  {
    lines: get_stdin_lines_width(text),
    words: get_stdin_words_width(text),
    bytes: get_stdin_bytes_width(text)
  }
end

def generate_args_contents(files, option)
  width = collect_arg_width(files)
  files.map do |file|
    content = []
    content << count_arg_lines(file).to_s.rjust(width[:lines]) if option[:l]
    content << count_arg_words(file).to_s.rjust(width[:words]) if option[:w]
    content << count_arg_bytes(file).to_s.rjust(width[:bytes]) if option[:c]
    content << " #{file}"
    content.join('')
  end
end

def generate_total_contents(files, option)
  width = collect_arg_width(files)
  lines_total = files.inject(0) { |result, file| result + count_arg_lines(file) }
  words_total = files.inject(0) { |result, file| result + count_arg_words(file) }
  bytes_total = files.inject(0) { |result, file| result + count_arg_bytes(file) }
  content = []
  content << lines_total.to_s.rjust(width[:lines]) if option[:l]
  content << words_total.to_s.rjust(width[:words]) if option[:w]
  content << bytes_total.to_s.rjust(width[:bytes]) if option[:c]
  content << ' total'
  content.join('')
end

def generate_stdin_contents(text, option)
  width = collect_stdin_width(text)
  content = []
  content << count_stdin_lines(text).to_s.rjust(width[:lines]) if option[:l]
  content << count_stdin_words(text).to_s.rjust(width[:words]) if option[:w]
  content << count_stdin_bytes(text).to_s.rjust(width[:bytes]) if option[:c]
  content.join('')
end

main
