# frozen_string_literal: true

require_relative 'directory_content'

class LongFormat
  def initialize(file_names)
    @file_names = file_names
    @number_of_links_width = calc_width(&:number_of_links)
    @owner_name_width = calc_width(&:owner_name)
    @group_name_width = calc_width(&:group_name)
    @number_of_bytes_width = calc_width(&:number_of_bytes)
    @total_blocks = calc_total_number_of_blocks
  end

  def fit_in
    @file_names.map do |file_name|
      content = DirectoryContent.new(file_name)
      format(
        "%<mode>s\s\s%<links>s\s%<owner>s\s\s%<group>s\s\s%<bytes>s\s%<date>s\s%<pass>s",
        mode: content.file_mode,
        links: content.number_of_links.rjust(@number_of_links_width),
        owner: content.owner_name.ljust(@owner_name_width),
        group: content.group_name.ljust(@group_name_width),
        bytes: content.number_of_bytes.rjust(@number_of_bytes_width),
        date: content.last_modified_date,
        pass: content.path_name
      )
    end.unshift("total\s#{@total_blocks}")
  end

  private

  def calc_width
    @file_names.map do |file_name|
      yield DirectoryContent.new(file_name)
    end.max_by(&:length).length
  end

  def calc_total_number_of_blocks
    @file_names.inject(0) do |total, file_name|
      total + DirectoryContent.new(file_name).number_of_blocks
    end
  end
end
