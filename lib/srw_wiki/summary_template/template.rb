require 'srw_wiki/summary_template/item'

module SrwWiki
  module SummaryTemplate
    # 概要テンプレートを示すクラス。
    class Template
      # テンプレート名
      # @return [String]
      attr_accessor :name
      # 項目のグループの配列
      # @return [Array<>]
      attr_reader :item_groups

      # 概要テンプレートを初期化する
      # @param [String] name テンプレート名
      def initialize(name = '概要')
        @name = name
        @item_groups = []
      end

      # すべての項目のウィキテキストを得る
      # @return [String]
      def items_wiki_text
        lines = @item_groups.flat_map.with_index { |items, group_index|
          start_num = 10 * group_index
          items.map.with_index { |item, item_index|
            item.to_wiki_text(start_num + item_index)
          }
        }
        lines.join("\n")
      end

      # ハッシュテーブルから概要テンプレートに変換する
      # @param [Hash] 概要テンプレートの内容が含まれたハッシュテーブル
      # @return [Template] 概要テンプレート
      def self.from_hash(hash)
        name = hash['name']
        template = name ? self.new(name) : self.new

        item_groups = hash['item_groups']
        item_groups.each do |group|
          template.item_groups << group.map { |item_data| Item.from_parsed(item_data) }
        end

        template
      end
    end
  end
end
