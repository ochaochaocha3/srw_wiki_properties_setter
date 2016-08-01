class CharacterPropertiesSetter
  # [[name::value]] 形式でプロパティを設定するセッターを返す
  # @param [String] name プロパティ名
  # @return [Proc]
  def self.simple_property_setter(name)
    ->(value) { "[[#{name}::#{value}]]" }
  end

  # {{ name|value }} 形式でテンプレートを設定するセッターを返す
  # @param [String] name テンプレート名
  # @return [Proc]
  def self.simple_template_setter(name)
    ->(value) { "{{#{name}|#{value}}}" }
  end

  # 単位付きプロパティを設定するセッターを返す
  # @param [String] name プロパティ名
  # @return [Proc]
  def self.property_with_unit_setter(name)
    lambda { |value|
      value.gsub(/(\d+)\s*(\w+)/) { "[[#{name}::#{$1} #{$2}]]" }
    }
  end

  # リンクを置換するセッターを返す
  # @param [String] format 書式。%s を 1 つ入れること
  # @return [Proc]
  def self.link_replacer(format)
    lambda { |value|
      value.gsub(/\[\[(.+?)\]\]/) { format % $1 }
    }
  end

  TEMPLATE_SETTER = {
    '外国語表記' => simple_property_setter('外国語表記'),
    '声優' => simple_template_setter('声優'),
    '種族' => lambda { |value|
      value.gsub(%r!([^()（）、,/\s]+)!) { "[[種族::#{$1}]]" }
    },
    '性別' => simple_property_setter('性別'),
    '年齢' => lambda { |value|
      value.gsub(/(\d+)歳/) { "[[年齢::#{$1}]]歳" }
    },
    '身長' => property_with_unit_setter('身長'),
    '体重' => property_with_unit_setter('体重'),
    '血液型' => lambda { |value|
      value.gsub(/(.+?)型/) { "[[血液型::#{$1}]]型" }
    },
    '所属' => link_replacer('{{所属 (人物)|%s}}'),
    '階級' => simple_property_setter('階級'),
    '役職' => simple_property_setter('役職'),
    '称号' => simple_property_setter('称号'),
    '主な搭乗機' => link_replacer('[[搭乗機::%s]]'),
    'キャラクターデザイン' => simple_template_setter('キャラクターデザイン')
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
