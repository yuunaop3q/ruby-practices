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
  frames << (s[0] == 10 ? [s.shift] : s)

  if frames[10]
    frames[9].concat(frames[10])
    frames.pop
  end
end

def strike?(frame)
  frame[0] == 10
end

point = frames.each_with_index.sum do |frame, i|
  if i < 9
    if strike?(frame)
      if i != 8 && strike?(frames[i + 1])
        10 + frames[i + 1][0] + frames[i + 2][0]
      else
        10 + frames[i + 1][0] + frames[i + 1][1]
      end
    elsif frame.sum == 10
      10 + frames[i + 1][0]
    else
      frame.sum
    end
  else
    frames[9].sum
  end
end
puts point
