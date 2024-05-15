#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

def exec
  records = ARGV[0].split(',')
  game = Game.new(records)
  puts game.exec
end

exec
