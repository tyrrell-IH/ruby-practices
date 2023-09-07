#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# 列の幅が8の倍数になるように設定しています。
MULTIPLE_OF_COLUMN_WIDTH = 8

def main
  option = parse_options
  texts = ARGV.empty? ? Array($stdin.read) : read_files(ARGV)
  puts generate_contents(texts, option)
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

def read_files(files)
  files.map { |file| File.read(file) }
end

def count_lines(text)
  text.lines.size
end

def count_words(text)
  words = text.split(/\s/)
  words.count { |word| !word.empty? }
end

def count_bytes(text)
  text.bytesize
end

def count_total_lines(texts)
  texts.inject(0) { |result, text| result + count_lines(text) }
end

def count_total_words(texts)
  texts.inject(0) { |result, text| result + count_words(text) }
end

def count_total_bytes(texts)
  texts.inject(0) { |result, text| result + count_bytes(text) }
end

# 行数、単語数、バイト数の各文字数の最大値より大きく、かつ8の倍数の内で最小の数を列の幅とします。
def get_lines_width(texts)
  max_length =
    if ARGV.size >= 2
      count_total_lines(texts).to_s.length
    else
      count_lines(*texts).to_s.length
    end
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_words_width(texts)
  max_length =
    if ARGV.size >= 2
      count_total_words(texts).to_s.length
    else
      count_words(*texts).to_s.length
    end
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def get_bytes_width(texts)
  max_length =
    if ARGV.size >= 2
      count_total_bytes(texts).to_s.length
    else
      count_bytes(*texts).to_s.length
    end
  (max_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def generate_total_contents(texts, option)
  width =
    {
      lines: get_lines_width(texts),
      words: get_words_width(texts),
      bytes: get_bytes_width(texts)
    }
  content = []
  content << count_total_lines(texts).to_s.rjust(width[:lines]) if option[:l]
  content << count_total_words(texts).to_s.rjust(width[:words]) if option[:w]
  content << count_total_bytes(texts).to_s.rjust(width[:bytes]) if option[:c]
  content << ' total'
  content.join('')
end

def generate_contents(texts, option)
  width =
    {
      lines: get_lines_width(texts),
      words: get_words_width(texts),
      bytes: get_bytes_width(texts)
    }
  contents =
    texts.map.with_index do |text, i|
      content = []
      content << count_lines(text).to_s.rjust(width[:lines]) if option[:l]
      content << count_words(text).to_s.rjust(width[:words]) if option[:w]
      content << count_bytes(text).to_s.rjust(width[:bytes]) if option[:c]
      content << " #{ARGV[i]}"
      content.join('')
    end
  contents.push(generate_total_contents(texts, option)) if ARGV.size >= 2
  contents
end

main
