#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# 列の幅が8の倍数になるように設定しています。
MULTIPLE_OF_COLUMN_WIDTH = 8

def main
  option = parse_options
  if ARGV.empty?
    text = $stdin.read
    puts generate_main_contents_given_stdin(text, option)
  else
    files = ARGV
    puts generate_main_contents_given_args(files, option)
    puts generate_total_contents_given_args(files, option) if files.size >= 2
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

def count_lines_given_args(file)
  File.read(file).lines.size
end

def count_words_given_args(file)
  words = File.read(file).split(/\s/)
  words.count { |word| !word.empty? }
end

def count_bytes_given_args(file)
  File.read(file).bytesize
end

def count_total_lines_given_args(files)
  files.inject(0) { |result, file| result + count_lines_given_args(file) }
end

def count_total_words_given_args(files)
  files.inject(0) { |result, file| result + count_words_given_args(file) }
end

def count_total_bytes_given_args(files)
  files.inject(0) { |result, file| result + count_bytes_given_args(file) }
end

def count_lines_given_stdin(text)
  text.lines.size
end

def count_words_given_stdin(text)
  words = text.split(/\s/)
  words.count { |word| !word.empty? }
end

def count_bytes_given_stdin(text)
  text.bytesize
end

# 行数、単語数、バイト数の各文字数の最大値より大きく、かつ8の倍数の内で最小の数を列の幅とします。
def get_lines_width_given_args(files)
  max_file = files.max_by { |file| count_lines_given_args(file).to_s.length }
  max_length =
    if files.size >= 2
      count_total_lines_given_args(files).to_s.length
    else
      count_lines_given_args(max_file).to_s.length
    end
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_words_width_given_args(files)
  max_file = files.max_by { |file| count_words_given_args(file).to_s.length }
  max_length =
    if files.size >= 2
      count_total_words_given_args(files).to_s.length
    else
      count_words_given_args(max_file).to_s.length
    end
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_bytes_width_given_args(files)
  max_file = files.max_by { |file| count_bytes_given_args(file).to_s }
  max_length =
    if files.size >= 2
      count_total_bytes_given_args(files).to_s.length
    else
      count_bytes_given_args(max_file).to_s.length
    end
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def collect_width_given_args(files)
  {
    lines: get_lines_width_given_args(files),
    words: get_words_width_given_args(files),
    bytes: get_bytes_width_given_args(files)
  }
end

def get_lines_width_given_stdin(text)
  length = count_lines_given_stdin(text).to_s.length
  (length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_words_width_given_stdin(text)
  length = count_words_given_stdin(text).to_s.length
  (length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_bytes_width_given_stdin(text)
  length = count_bytes_given_stdin(text).to_s.length
  (length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def collect_width_given_stdin(text)
  {
    lines: get_lines_width_given_stdin(text),
    words: get_words_width_given_stdin(text),
    bytes: get_bytes_width_given_stdin(text)
  }
end

def generate_main_contents_given_args(files, option)
  width = collect_width_given_args(files)
  files.map do |file|
    content = []
    content << count_lines_given_args(file).to_s.rjust(width[:lines]) if option[:l]
    content << count_words_given_args(file).to_s.rjust(width[:words]) if option[:w]
    content << count_bytes_given_args(file).to_s.rjust(width[:bytes]) if option[:c]
    content << " #{file}"
    content.join('')
  end
end

def generate_total_contents_given_args(files, option)
  width = collect_width_given_args(files)
  num_lines = count_total_lines_given_args(files)
  num_words = count_total_words_given_args(files)
  num_bytes = count_total_bytes_given_args(files)
  content = []
  content << num_lines.to_s.rjust(width[:lines]) if option[:l]
  content << num_words.to_s.rjust(width[:words]) if option[:w]
  content << num_bytes.to_s.rjust(width[:bytes]) if option[:c]
  content << ' total'
  content.join('')
end

def generate_main_contents_given_stdin(text, option)
  width = collect_width_given_stdin(text)
  content = []
  content << count_lines_given_stdin(text).to_s.rjust(width[:lines]) if option[:l]
  content << count_words_given_stdin(text).to_s.rjust(width[:words]) if option[:w]
  content << count_bytes_given_stdin(text).to_s.rjust(width[:bytes]) if option[:c]
  content.join('')
end

main
