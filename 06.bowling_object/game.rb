# frozen_string_literal: true

require_relative 'shot'

class Game
  attr_reader :total_score

  def initialize(scores)
    @scores = scores
    @total_score = 0
  end

  def add_scores_to_total
    @scores.each do |score|
      @total_score += Shot.new(score).score
    end
  end
end

scores = ARGV[0].split(',')
game = Game.new(scores)
game.add_scores_to_total
puts game.total_score
