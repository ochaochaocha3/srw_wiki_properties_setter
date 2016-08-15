require 'stringio'
require 'srw_wiki/property_setter'
require 'srw_wiki/line'

module SrwWiki
  class MechaPropertySetter < PropertySetter
    TEMPLATE_SETTER = {
      '外国語表記' => simple_property_setter('外国語表記'),
      '登場作品' => lambda { |value, is_next_list_item|
        if is_next_list_item
          list_item_setter = lambda { |value_li, is_next_list_item_li|
            modified, _ = link_to_template('登場作品 (メカ)')[value_li, false]
            [modified, list_item_setter]
          }
          [value, list_item_setter]
        else
          link_to_template('登場作品 (メカ)')[value, is_next_list_item]
        end
      },
      '声優' => simple_template_setter('声優'),
      '分類' => link_to_property('分類'),
      '型式番号' => simple_property_setter('型式番号'),
      '頭頂高' => property_with_unit_setter('頭頂高'),
      '全高' => property_with_unit_setter('全長'),
      '全長' => property_with_unit_setter('全長'),
      '重量' => property_with_unit_setter('重量'),
      '動力' => simple_property_setter('動力'),
      '出力' => property_with_unit_setter('出力'),
      '推進機関' => simple_property_setter('推進機関'),
      '推力' => property_with_unit_setter('推力'),
      '装甲材質' => simple_property_setter('装甲材質'),
      'MMI' => simple_property_setter('MMI'),
      '開発' => link_to_property('開発'),
      '開発者' => link_to_property('開発'),
      '所属' => lambda { |value, is_next_list_item|
        if is_next_list_item
          list_item_setter = lambda { |value_li, is_next_list_item_li|
            modified, _ = link_to_template('所属 (メカ)')[value_li, false]
            [modified, list_item_setter]
          }
          [value, list_item_setter]
        else
          link_to_template('所属 (メカ)')[value, is_next_list_item]
        end
      },
      '主なパイロット' => link_to_property('パイロット'),
      'キャラクターデザイン' => simple_template_setter('キャラクターデザイン'),
      'メカニックデザイン' => simple_template_setter('メカニックデザイン')
    }
  end
end
