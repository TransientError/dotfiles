function dedupe
  cat - | awk '!seen[$0]++'
end

