# frozen_string_literal: true

def take_files
  Dir.glob('*')
end

def print_files_in_columns(col_size)
  sort_files = take_files.sort
  maxlen = sort_files.max_by(&:length).length
  lines = (sort_files.size / col_size.to_f).ceil
  sort_files << nil.to_s until (sort_files.size % col_size).zero?

  sort_array = sort_files.each_slice(lines).to_a

  transposed_array = sort_array.transpose

  transposed_array.each do |file|
    puts file.map { |f| f.ljust(maxlen + 10) }.join
  end
end

print_files_in_columns(3)
