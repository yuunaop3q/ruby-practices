# frozen_string_literal: true

require 'date'
require 'optparse'

today = Date.today

# コマンドライン引数の設定

opt = OptionParser.new
params = opt.getopts('m:', 'y:')

# コマンドライン引数が設定されていない時とされている時の年月の表示

month = if params['m'].nil?
          today.month
        else
          params['m'].to_i
        end

year = if params['y'].nil?
         today.year
       else
         params['y'].to_i
       end

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)
print "       #{month}月#{year}\n"
# 曜日の表示

day_of_weeks = %w[日 月 火 水 木 金 土]
puts day_of_weeks.join(' ')

#  1行目の空白（初日が何曜日始まりかを表す）のコード

print '   ' * first_day.wday

# 月末までの数字を表すコード

(first_day.day..last_day.day).each do |days|
  if days < 10
    print(" #{days} ")
  else
    print("#{days} ")
  end
  print "\n" if Date.new(year, month, days).saturday?
end
