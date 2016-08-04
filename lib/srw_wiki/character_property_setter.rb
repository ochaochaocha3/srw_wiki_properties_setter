require 'stringio'
require 'srw_wiki/property_setter'
require 'srw_wiki/line'

module SrwWiki
  class CharacterPropertySetter < PropertySetter
    TEMPLATE_SETTER = {
      '外国語表記' => simple_property_setter('外国語表記'),
      '登場作品' => lambda { |value, is_next_list_item|
        if is_next_list_item
          list_item_setter = lambda { |value_li, is_next_list_item_li|
            modified, _ = link_to_template('登場作品 (人物)')[value_li, false]
            [modified, list_item_setter]
          }
          [value, list_item_setter]
        else
          link_to_template('登場作品 (人物)')[value, is_next_list_item]
        end
      },
      '声優' => simple_template_setter('声優'),
      '種族' => simple_property_setter('種族'),
      '性別' => simple_property_setter('性別'),
      '年齢' => lambda {
        _setter = lambda { |value, is_next_list_item|
          [value.gsub(/(\d+)歳/) { "[[年齢::#{$1}]]歳" },
           is_next_list_item ? _setter : nil]
        }
      }.call,
      '身長' => property_with_unit_setter('身長'),
      '体重' => property_with_unit_setter('体重'),
      '血液型' => lambda {
        _setter = lambda { |value, is_next_list_item|
          [value.gsub(/(.+?)型/) { "[[血液型::#{$1}]]型" },
           is_next_list_item ? _setter : nil]
        }
      }.call,
      '所属' => lambda { |value, is_next_list_item|
        if is_next_list_item
          list_item_setter = lambda { |value_li, is_next_list_item_li|
            modified, _ = link_to_template('所属 (人物)')[value_li, false]
            [modified, list_item_setter]
          }
          [value, list_item_setter]
        else
          link_to_template('所属 (人物)')[value, is_next_list_item]
        end
      },
      '階級' => simple_property_setter('階級'),
      '役職' => simple_property_setter('役職'),
      '称号' => simple_property_setter('称号'),
      '主な搭乗機' => link_to_property('搭乗機'),
      'キャラクターデザイン' => simple_template_setter('キャラクターデザイン')
    }

    def self.execute(source)
      lines = Line.from_lines(source.lines.map(&:chomp))

      list_setter = nil
      modified_lines = lines.map do |line|
        case
        when line.summary?
          label_without_link = remove_link(line.label)

          if setter = TEMPLATE_SETTER[label_without_link]
            modified, list_setter = setter[line.value, line.is_next_list_item?]
            "*#{line.label}：#{modified}"
          else
            line.content
          end
        when line.list_item?
          modified, _ = list_setter[line.value, line.is_next_list_item?]
          "**#{modified}"
        end
      end

      modified_lines.join("\n")
    end
  end
end
