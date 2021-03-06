require 'stringio'
require 'srw_wiki/property_setter'
require 'srw_wiki/line'

module SrwWiki
  class CharacterPropertySetter < PropertySetter
    TEMPLATE_SETTER = {
      '読み' => simple_property_setter('読み'),
      '漢字表記' => simple_property_setter('漢字表記'),
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
      '本名' => simple_property_setter('本名'),
      '別名' => simple_property_setter('別名'),
      '異名' => simple_property_setter('異名'),
      '愛称' => simple_property_setter('愛称'),
      '種族' => simple_property_setter('種族'),
      '性別' => simple_property_setter('性別'),
      '生年月日' => identity,
      '誕生日' => identity,
      '年齢' => lambda {
        _setter = lambda { |value, is_next_list_item|
          [value.gsub(/(\d+)歳/) { "[[年齢::#{$1}]]歳" }, _setter]
        }
      }.call,
      '身長' => property_with_unit_setter('身長'),
      '体重' => property_with_unit_setter('体重'),
      '血液型' => lambda {
        _setter = lambda { |value, is_next_list_item|
          [value.gsub(/(.+?)型/) { "[[血液型::#{$1}]]型" }, _setter]
        }
      }.call,
      '出身' => simple_property_setter('出身'),
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
      '最終学歴' => identity,
      '階級' => simple_property_setter('階級'),
      '役職' => simple_property_setter('役職'),
      '称号' => simple_property_setter('称号'),
      'コールサイン' => simple_property_setter('コールサイン'),
      '搭乗機' => link_to_property('搭乗機'),
      '主な搭乗機' => link_to_property('搭乗機'),
      'キャラクターデザイン' => simple_template_setter('キャラクターデザイン'),
      'メカニックデザイン' => simple_template_setter('メカニックデザイン')
    }

    def self.execute(source)
      super(source, '登場人物概要')
    end
  end
end
