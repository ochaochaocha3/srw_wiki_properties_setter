while line = gets
  puts(
    line.sub(/\A(:*;)\[\[(.+?)\]\]/) { "#{$1}{{参戦作品 (メカ・人物)|#{$2}}}" }
  )
end
