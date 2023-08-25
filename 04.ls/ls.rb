#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

NUMBER_OF_COLUMNS = 3
MULTIPLE_OF_COLUMN_WIDTH = 8

def main
  options = parse_options
  files = acquire_files(a_option: options[:a], r_option: options[:r])
  if options[:l]
    puts generate_file_info_to_display(files)
  else
    puts generate_file_name_to_display(files)
  end
end

def parse_options
  params = {}
  opt = OptionParser.new
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse!
  params
end

def acquire_files(a_option: false, r_option: false)
  files = a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  r_option ? files.reverse : files
end

def transpose_by_each_columns(files)
  files << '' while files.size % NUMBER_OF_COLUMNS != 0
  lines = files.size / NUMBER_OF_COLUMNS
  files.each_slice(lines).to_a.transpose
end

def get_column_width(files)
  max_of_length = files.max_by(&:length).length
  (max_of_length.next..).find { |n| (n % MULTIPLE_OF_COLUMN_WIDTH).zero? }
end

def generate_file_name_to_display(files)
  column_width = get_column_width(files)
  transposed_files = transpose_by_each_columns(files)
  transposed_files.map do |files_each_lines|
    files_each_lines.map { |file| file.ljust(column_width) }.join('')
  end
end

def get_oct_mode(file)
  File.lstat(file).mode.to_s(8).rjust(6, '0')
end

def check_stickybit_sgid_suid(oct_mode, permission)
  permission[8] = oct_mode[5].to_i.odd? ? 't' : 'T' if oct_mode[2] == '1'
  permission[5] = oct_mode[4].to_i.odd? ? 's' : 'S' if oct_mode[2] == '2'
  permission[2] = oct_mode[3].to_i.odd? ? 's' : 'S' if oct_mode[2] == '4'
  permission
end

def get_permission(oct_mode)
  permission_data = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }
  permission = oct_mode[3..5].chars.map { |n| permission_data[n] }.join('')
  check_stickybit_sgid_suid(oct_mode, permission)
end

def get_file_mode(file)
  file_type = { '04' => 'd', '10' => '-', '12' => 'l' }
  oct_mode = get_oct_mode(file)
  "#{file_type[oct_mode[0..1]]}#{get_permission(oct_mode)}"
end

def get_link_number(file)
  File.lstat(file).nlink.to_s
end

def get_user_name(file)
  Etc.getpwuid(File.lstat(file).uid).name
end

def get_group_name(file)
  Etc.getgrgid(File.lstat(file).gid).name
end

def get_byte(file)
  File.lstat(file).size.to_s
end

def get_link_number_max_length(files)
  files.map { |file| get_link_number(file) }.max_by(&:length).length
end

def get_user_name_max_length(files)
  files.map { |file| get_user_name(file) }.max_by(&:length).length
end

def get_group_name_max_length(files)
  files.map { |file| get_group_name(file) }.max_by(&:length).length
end

def get_byte_max_length(files)
  files.map { |file| get_byte(file) }.max_by(&:length).length
end

def get_last_modified_date(file)
  modified_time = File.lstat(file).mtime
  modified_time.to_date.between?(Date.today.prev_month(6), Date.today) ? modified_time.strftime('%b %e %H:%M') : modified_time.strftime('%b %e  %Y')
end

def get_file_name(file)
  File.lstat(file).symlink? ? "#{file} -> #{File.readlink(file)}" : file
end

def generate_file_info_to_display(files)
  link_max_length = get_link_number_max_length(files)
  user_max_length = get_user_name_max_length(files)
  group_max_length = get_group_name_max_length(files)
  byte_max_length = get_byte_max_length(files)
  files.map do |file|
    file_info = [
      get_file_mode(file),
      get_link_number(file).rjust(link_max_length + 1),
      get_user_name(file).ljust(user_max_length + 1),
      get_group_name(file).ljust(group_max_length + 1),
      get_byte(file).rjust(byte_max_length),
      get_last_modified_date(file),
      get_file_name(file)
    ]
    file_info.join(' ')
  end
end

main
