module SrwWiki
  module SummaryTemplate
    # 概要の項目を示す構造体。
    class Item
      # 項目のラベル
      # @return [String]
      attr_accessor :label
      # 項目のデータ
      # @return [String]
      attr_accessor :data

      # 概要の項目を初期化する
      # @param [String] label 項目のラベル
      # @param [String] data 項目のデータ
      def initialize(label, data)
        @label = label
        @data = data
      end

      # ウィキテキストに変換する
      # @param [Integer] num 項目の番号
      # @return [String]
      def to_wiki_text(num)
        lines = [
          "| label#{num} = #{@label}",
          "| data#{num} = {{{#{@data}|}}}"
        ]
        lines.join("\n")
      end

      # YAMLファイルを解析して得られた値から概要の項目に変換する
      # @param [String, Array<String>] YAMLファイルを解析して得られた概要の項目の値
      # @return [Item]
      def self.from_parsed(value)
        case value
        when String
          self.new(value, value)
        when Array
          data = value[0]
          label = value[1]

          raise TypeError, 'label must be a String' unless label.kind_of?(String)
          raise TypeError, 'data must be a String' unless data.kind_of?(String)

          self.new(label, data)
        else
          raise TypeError, 'item must be a String or an Array'
        end
      end
    end
  end
end
