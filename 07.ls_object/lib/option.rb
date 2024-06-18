# frozen_string_literal: true

require 'optparse'

class Option
  @params = {}
  opt = OptionParser.new
  opt.on('-a') { |v| @params[:a] = v }
  opt.on('-r') { |v| @params[:r] = v }
  opt.on('-l') { |v| @params[:l] = v }
  opt.parse!

  def self.a?
    @params[:a]
  end

  def self.r?
    @params[:r]
  end

  def self.l?
    @params[:l]
  end
end
