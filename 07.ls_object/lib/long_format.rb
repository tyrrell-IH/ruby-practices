# frozen_string_literal: true

require_relative 'content'

class LongFormat
  def initialize(file_names)
    @file_names = file_names
    @number_of_links_width = calc_width(&:number_of_links)
    @owner_name_width = calc_width(&:owner_name)
    @group_name_width = calc_width(&:group_name)
    @number_of_bytes_width = calc_width(&:number_of_bytes)
  end

  def adjust
    @file_names.map do |file_name|
      content = Content.new(file_name)
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
    end
  end

  def calc_width
    @file_names.map do |file_name|
      yield Content.new(file_name)
    end.max_by(&:length).length
  end
end
