# frozen_string_literal: true

require 'etc'
require 'date'

class Content
  PERMISSION = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze
  FILE_TYPE = {
    '04' => 'd',
    '10' => '-',
    '12' => 'l'
  }.freeze

  def initialize(file_name)
    @file_name = file_name
    @file_info = File.lstat(@file_name)
    @octal_file_mode = @file_info.mode.to_s(8).rjust(6, '0')
  end

  def file_mode
    permission = @octal_file_mode[3..5].chars.map { |n| PERMISSION[n] }.join('')
    permission[8] = @octal_file_mode[5].to_i.odd? ? 't' : 'T' if @octal_file_mode[2] == '1'
    permission[5] = @octal_file_mode[4].to_i.odd? ? 's' : 'S' if @octal_file_mode[2] == '2'
    permission[2] = @octal_file_mode[3].to_i.odd? ? 's' : 'S' if @octal_file_mode[2] == '4'
    FILE_TYPE[@octal_file_mode[0..1]] + permission
  end

  def number_of_links
    @file_info.nlink.to_s
  end

  def owner_name
    Etc.getpwuid(@file_info.uid).name
  end

  def group_name
    Etc.getgrgid(@file_info.gid).name
  end

  def number_of_bytes
    @file_info.size.to_s
  end

  def last_modified_date
    modified_time = @file_info.mtime
    if modified_time.to_date.between?(Date.today.prev_month(6), Date.today)
      modified_time.strftime("%_m\s%e\s%H:%M")
    else
      modified_time.strftime("%_m\s%e\s\s%Y")
    end
  end

  def path_name
    @file_info.symlink? ? "#{@file_name}\s->\s#{File.readlink(@file_name)}" : @file_name
  end

  def number_of_blocks
    @file_info.blocks
  end
end
