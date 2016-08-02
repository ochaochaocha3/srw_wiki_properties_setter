require 'stringio'
require 'srw_wiki/property_setter'

module SrwWiki
  class CharacterPropertySetter < PropertySetter
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

    def self.execute(source)
      lines = source.lines
      n_lines = lines.length

      out = StringIO.new

      i = 0
      while i < n_lines
        line = lines[i].chomp

        m = line.match(/\A\*\s*([^\*].+?)[:：]/)
        unless m
          out.puts(line)
          i += 1
          next
        end

        label = remove_link(m[1])
        case
        when label == '登場作品'
          out.puts(line)
          i += 1

          while i < n_lines
            line_work = lines[i].chomp
            break unless /\A\*{2}\s*[^\*]/ === line_work

            modified_line_work = line_work.gsub(/\[\[(.+?)\]\]/) {
              "{{登場作品 (人物)|#{$1}}}"
            }
            out.puts(modified_line_work)

            i += 1
          end
        when setter = TEMPLATE_SETTER[label]
          out.puts("*#{m[1]}：#{setter[m.post_match.strip]}")
          i += 1
        else
          out.puts(line)
          i += 1
        end
      end

      out.string
    end
  end
end
