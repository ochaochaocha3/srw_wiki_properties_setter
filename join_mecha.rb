while line = gets
  puts(
    line.sub(/\A(:*;)\[\[(.+?)\]\]/) { "#{$1}{{参戦作品 (メカ)|#{$2}}}" }
  )
end
