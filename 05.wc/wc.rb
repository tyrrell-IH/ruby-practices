#! /usr/bin/env ruby
# frozen_string_literal: true

def make_text(file)
  File.read(file)
end

def count_lines(text)
  text.lines.size
end

def count_words(text)
  text.split(/\s/).reject{|word| word.length.zero?}.size
end

def count_bytes(text)
  text.bytesize
end

if ARGV.empty?
  text = $stdin.read
  puts " #{count_lines(text)} #{count_words(text)} #{count_bytes(text)}"
else
  ARGV.each do |file|
    text = make_text(file)
    puts " #{count_lines(text)} #{count_words(text)} #{count_bytes(text)} #{file}"
  end
end
