# frozen_string_literal: true
require 'debug'
require 'optparse'

def take_files
  Dir.glob('*').sort
end

def print_files_in_columns(col_size, reverse_order)
  use_files = take_files
  maxlen = use_files.max_by(&:length).length
  lines = calculate_number_of_rows(use_files, col_size)
  use_files = fill_empty_files(use_files, lines, col_size)
  display_files_in_columns(transpose_files(use_files, lines), maxlen, reverse_order)
end
def calculate_number_of_rows(file_count, col_size)
  (file_count.size / col_size.to_f).ceil
end

def fill_empty_files(files, lines, col_size)
  extra_files = lines * col_size - files.size
  files.concat([nil] * extra_files)
end

def transpose_files(files, lines)
  # binding.irb
    files.each_slice(lines).to_a.transpose
end

def display_files_in_columns(transposed_array, maxlen, reverse_order)
  # binding.irb
  transposed_array.reverse.each do |file|
    arrange_files = file.compact.map { |f| f.to_s.ljust(maxlen + 10) }
    if reverse_order
      puts arrange_files.sort.reverse.join
    else
      puts arrange_files.join
    end
  end
end

options = {}
OptionParser.new do |opts|
  opts.on('-r') do
    options[:reverse] = true
  end
end.parse!

print_files_in_columns(3, options[:reverse])
