# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << nil.to_i
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << if s[0] == 10
              [s.shift]
            else
              s
            end

  next unless frames[10]

  frames[10].each do |value|
    frames[9] << value
  end
  frames.pop
end

point = 0
frames.each_with_index do |frame, i|
  if i < 9
    if  frame[0] == 10
      begin
        point += 10 + frames[i + 1][0] + frames[i + 1][1]
      rescue StandardError
        # ↑そもそもエラーが出ないようにしないといけないと思うのですが、調べると例外処理というやり方があったので今回実践してみました。
        point += 10 + frames[i + 1][0] + frames[i + 2][0]
      end

    elsif frame.include?(frame[2])
      point += frame[0] + frame[1] + frame[2]

    elsif frame[0] + frame[1] == 10
      point += 10 + frames[i + 1][0]

    else
      point += frame[0] + frame[1]
    end
  elsif i == 9 && frame[0] == 10
    point += frame[0] + frame[1] + frame[2]
  elsif i == 9 && frame[1] == 10
    point += frame[0] + frame[1] + frame[2]
  elsif i == 9 && frame[0] + frame[1] == 10
    point += frame[0] + frame[1] + frame[2]
  else
    point += frames[9][0] + frames[9][1]
  end
end

puts point
