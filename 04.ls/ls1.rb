# frozen_string_literal: true

require 'etc'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') do
    options[:l] = true
  end
end.parse!

COL_SIZE = 3

def print_files_in_columns(col_size)
  use_files = take_files
  maxlen = use_files.max_by(&:length).length
  lines = calculate_number_of_rows(use_files, col_size)
  use_files = fill_empty_files(use_files, lines, col_size)
  display_files_in_columns(transpose_files(use_files, lines), maxlen)
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
    arrange_files = file.compact.map { |f| f.to_s.ljust(maxlen + 10) }
    puts arrange_files.join
  end
end

def first_hash_symbols(align_permissions)
  align_permissions.gsub(
    /^(01|02|04|06|10|12|14)/,
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  )
end

def hash_symbols
  {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }
end

def display_detailed_file_info(file_path)
  file_stat = File::Stat.new(file_path)
  permissions = permissions(file_stat)
  hard_links = hard_links(file_stat)
  user_name = user_name(file_stat)
  group_name = group_name(file_stat)
  size = size(file_stat)
  modified_time = modified_time(file_stat)
  file_name = file_name(file_path)
  "#{permissions} #{hard_links} #{user_name} #{group_name} #{size} #{modified_time} #{file_name}"
end

def take_files
  Dir.glob('*').sort
end

def permissions(file_stat)
  perm = file_stat.mode.to_s(8)
  format('%06o', perm)
  permissions_replacement(file_stat)
end

def hard_links(file_stat)
  file_stat.nlink.to_s.rjust(2)
end

def user_name(file_stat)
  user_id = file_stat.uid
  Etc.getpwuid(user_id).name.ljust(8)
end

def group_name(file_stat)
  group_id = file_stat.gid
  Etc.getgrgid(group_id).name.ljust(8)
end

def size(file_stat)
  file_stat.size.to_s.rjust(8)
end

def modified_time(file_stat)
  file_stat.ctime.strftime('%m %d %H:%M')
end

def file_name(file_path)
  File.basename(file_path)
end

def permissions_replacement(file_stat)
  align_permissions = format('%06o', file_stat.mode)
  first_permissions = first_hash_symbols(align_permissions)
  [
    first_hash_symbols(align_permissions).match(/(p|c|d|b|-|l|s)/),
    specifying_permissions(first_permissions, hash_symbols) # permissionの文字列を返すように修正する
  ].join
end

def specifying_permissions(first_permissions, hash_symbols)
  first_permissions[2..].chars.map { |digit| hash_symbols[digit] }
end

def file_info_to_array(take_files, directory_path)
  take_files.map do |file|
    file_path = File.join(directory_path, file)
    display_detailed_file_info(file_path)
  end
end

def list_directory(directory_path, take_files, options, col_size)
  if options[:l]
    total_file_blocks = take_files.sum { |file| File.stat(file).blocks }
    puts "total #{total_file_blocks}"
    array_of_files = file_info_to_array(take_files, directory_path)
    puts array_of_files
  else
    col_size = COL_SIZE
    print_files_in_columns(col_size)
  end
end

directory_path = '/Users/chi/ruby-practices/04.ls'
list_directory(directory_path, take_files, options, COL_SIZE)
