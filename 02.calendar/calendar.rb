# frozen_string_literal: true

require 'date'
require 'optparse'

today = Date.today

# コマンドライン引数の設定

opt = OptionParser.new
params = opt.getopts('m:', 'y:')

# コマンドライン引数が設定されていない時とされている時の年月の表示

if params['m'].nil? && params ['y'].nil?
  month = today.mon
  year = today.year
elsif params['m'].nil? && params ['y']
  month = today.month
  year = params['y'].to_i
elsif params['m'] && params['y'].nil?
  month = params['m'].to_i
  year = today.year
else
  month = params['m'].to_i
  year = params['y'].to_i
end

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)
print "       #{month}月#{year}\n"
# 曜日の表示

day_of_weeks = %w[日 月 火 水 木 金 土]
day_of_weeks.each { |d| print d, ' ' }
puts
#  1行目の空白（初日が何曜日始まりかを表す）のコード

print '   ' * first_day.wday

# 月末までの数字を表すコード

(first_day.day..last_day.day).each do |number|
  if number < 10
    print(" #{number} ")
  else
    print("#{number} ")
  end
  print "\n" if Date.new(year, month, number).wday == 6
end
