class CharacterPropertiesSetter
  TEMPLATE_SETTER = {
    '声優' => lambda { |value|
      "{{声優|#{value}}}"
    },
    '種族' => lambda { |value|
      "[[種族::#{value}]]"
    },
    '性別' => lambda { |value|
      "[[性別::#{value}]]"
    },
    '年齢' => lambda { |value|
      value.gsub(/(\d+)歳/) { "[[年齢::#{$1}]]歳" }
    },
    '身長' => lambda { |value|
      value.gsub(/(\d+)\s*(\w+)/) { "[[身長::#{$1} #{$2}]]" }
    },
    '体重' => lambda { |value|
      value.gsub(/(\d+)\s*(\w+)/) { "[[体重::#{$1} #{$2}]]" }
    },
    '血液型' => lambda { |value|
      value.gsub(/(.+?)型/) { "[[血液型::#{$1}]]型" }
    },
    '所属' => lambda { |value|
      value.gsub(/\[\[(.+?)\]\]/) { "{{所属 (人物)|#{$1}}}" }
    },
    '階級' => lambda { |value|
      "[[階級::#{value}]]"
    },
    '役職' => lambda { |value|
      "[[役職::#{value}]]"
    },
    '称号' => lambda { |value|
      "[[称号::#{value}]]"
    },
    '主な搭乗機' => lambda { |value|
      value.gsub(/\[\[(.+?)\]\]/) { "[[搭乗機::#{$1}]]" }
    }
  }

  def execute
    lines = readlines
    n_lines = lines.length

    i = 0
    while i < n_lines
      line = lines[i].chomp

      m = line.match(/\A\*\s*([^\*].+?)[:：]/)
      unless m
        puts(line)
        i += 1
        next
      end

      label = remove_link(m[1])
      case
      when label == '登場作品'
        puts(line)
        i += 1

        while i < n_lines
          line_work = lines[i].chomp
          break unless /\A\*{2}\s*[^\*]/ === line_work

          modified_line_work = line_work.gsub(/\[\[(.+?)\]\]/) {
            "{{登場作品 (人物)|#{$1}}}"
          }
          puts(modified_line_work)

          i += 1
        end
      when setter = TEMPLATE_SETTER[label]
        puts("*#{m[1]}：#{setter[m.post_match.strip]}")
        i += 1
      else
        puts(line)
        i += 1
      end
    end
  end

  private

  def remove_link(label)
    m = label.match(/\[\[(.+?)\]\]/)
    return label unless m

    link_elements = m[1].split('|', 2)
    link_elements.last
  end
end

CharacterPropertiesSetter.new.execute
