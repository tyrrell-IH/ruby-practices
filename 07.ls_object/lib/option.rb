# frozen_string_literal: true

require 'optparse'

class Option
  @params = {}
  opt = OptionParser.new
  opt.on('-a') { |v| @params[:a] = v }
  opt.on('-r') { |v| @params[:r] = v }
  opt.on('-l') { |v| @params[:l] = v }
  opt.parse!

  def self.has_a?
    @params[:a] || false
  end

  def self.has_r?
    @params[:r] || false
  end

  def self.has_l?
    @params[:l] || false
  end
end