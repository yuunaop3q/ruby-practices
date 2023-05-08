# frozen_string_literal: true

def take_files
  Dir.glob('*').sort
end

def print_files_in_columns(col_size)
  use_files = take_files
  maxlen = use_files.max_by(&:length).length
  lines = (use_files.size / col_size.to_f).ceil
  use_files << nil.to_s until (use_files.size % col_size).zero?

  transposed_array = use_files.each_slice(lines).to_a.transpose

  transposed_array.each do |file|
    puts file.map { |f| f.ljust(maxlen + 10) }.join
  end
end

print_files_in_columns(3)
