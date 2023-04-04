# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
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

point = frames.each_with_index.sum do |frame, i|
  if i < 9
    if i != 8 && frames[i][0] == 10 && frames[i + 1][0] == 10
      10 + frames[i + 1][0] + frames[i + 2][0]
    elsif frame[0] == 10
      10 + frames[i + 1][0] + frames[i + 1][1]
    elsif i == 8 && frames[8][0] == 10 && frames[9][0] == 10
      20 + frames[i + 1][1]
    elsif frame[0] + frame[1] == 10
      10 + frames[i + 1][0]
    else
      frame[0] + frame[1]
    end
  else
    frames[9].sum
  end
end

puts point
