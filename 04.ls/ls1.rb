# frozen_string_literal: true

require 'etc'

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

def get_file_info(file_path)
  file_stat = File::Stat.new(file_path)
  permissions = get_permissions(file_stat)
  hard_links = get_hard_links(file_stat)
  user_name = get_user_name(file_stat)
  group_name = get_group_name(file_stat)
  size = get_size(file_stat)
  modified_time = get_modified_time(file_stat)
  file_name = get_file_name(file_path)
  "#{permissions} #{hard_links} #{user_name} #{group_name} #{size} #{modified_time} #{file_name}"
end

def files_list(directory_path)
  Dir.entries(directory_path) - ['.', '..']
end

def get_permissions(file_stat)
  perm = file_stat.mode.to_s(8)
  format('%06d', perm)
  permissions_replacement(file_stat)
end

def get_hard_links(file_stat)
  file_stat.nlink.to_s.rjust(2)
end

def get_user_name(file_stat)
  user_id = file_stat.uid
  Etc.getpwuid(user_id).name.ljust(8)
end

def get_group_name(file_stat)
  group_id = file_stat.gid
  Etc.getgrgid(group_id).name.ljust(8)
end

def get_size(file_stat)
  file_stat.size.to_s.rjust(8)
end

def get_modified_time(file_stat)
  file_stat.ctime.strftime('%m %d %H:%M')
end

def get_file_name(file_path)
  File.basename(file_path)
end

def permissions_replacement(file_stat)
  perm = file_stat.mode.to_s(8)
  align_permissions = format('%06d', perm)
  captured_strings = []
  first_permissions = first_hash_symbols(align_permissions)
  captured_strings << first_permissions.match(/(p|c|d|b|-|l|s)/)
  specifying_permissions(captured_strings, first_permissions, hash_symbols)
  captured_strings.join('')
end

def specifying_permissions(captured_strings, first_permissions, hash_symbols)
  captured_strings << first_permissions[2..].chars.map { |digit| hash_symbols[digit] }
end

def list_directory(directory_path, files_list)
  files_info = []
  total_size = 0
  files_list.each do |file|
    next if file.start_with?('.')

    file_path = File.join(directory_path, file)
    files_info << get_file_info(file_path)
    total_size += File.size(file_path)
  end
  puts "total #{total_size}"
  puts files_info.sort
end

directory_path = '/Users/chi/ruby-practices/04.ls'
list_directory(directory_path, files_list(directory_path))
