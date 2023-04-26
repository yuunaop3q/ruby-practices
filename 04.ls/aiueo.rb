# frozen_string_literal: true

def take_files
  Dir.glob('*').reject { |f| File.directory?(f) }
end

def print_files_in_columns(col_size)
  look_files = take_files
  sort_files = look_files.sort
  maxlen = sort_files.max_by { |e1| e1 }.length
  lines = (sort_files.size / col_size.to_f).ceil
  sort_files << nil.to_s until (sort_files.size % col_size).zero?

  array = []
  sort_files.each_slice(lines) do |f|
    array << f
  end

  transposed_array = array.transpose

  transposed_array.each do |file|
    file.map! { |f| f.ljust(maxlen + 10) }
    puts file.join("\t")
  end
end

print_files_in_columns(3)
