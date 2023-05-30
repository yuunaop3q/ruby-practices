# frozen_string_literal: true

require 'optparse'

def take_files
  Dir.glob('*').sort
end

def print_files_in_columns(col_size)
  use_files = take_files
  maxlen = use_files.max_by(&:length).length
  lines = calculate_number_of_rows(use_files, col_size)
  use_files = fill_empty_files(use_files, lines, col_size)
  if ARGV.include?('-r')
    display_files_in_columns_reverse(transpose_files(use_files, lines), maxlen)
  else
    display_files_in_columns(transpose_files(use_files, lines), maxlen)
  end
end

def calculate_number_of_rows(file_count, col_size)
  (file_count.size / col_size.to_f).ceil
end

def fill_empty_files(files, lines, col_size)
  extra_files = lines * col_size - files.size
  files.concat([nil] * extra_files)
end

def transpose_files(files, lines)
  files.each_slice(lines).to_a.transpose
end

def display_files_in_columns(transposed_array, maxlen)
  transposed_array.each do |file|
    puts file.map { |f| f.to_s.ljust(maxlen + 10) }.join
  end
end

def display_files_in_columns_reverse(transposed_array, maxlen)
  transposed_array.each do |file|
    puts file.map { |f| f.to_s.ljust(maxlen + 10) }.sort.reverse.join
  end
end

print_files_in_columns(3)
