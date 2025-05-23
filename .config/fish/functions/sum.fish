function sum
  cat - | awk 'BEGIN { sum = 0 } { sum += $1 } END { print sum }' $argv
end

