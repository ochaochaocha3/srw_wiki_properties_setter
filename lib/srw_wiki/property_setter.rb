module SrwWiki
  class PropertySetter
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

    # リンクを除去し、表示名を返す
    # @param [String] label 概要の箇条書きのラベル
    # @return [String]
    def self.remove_link(label)
      m = label.match(/\[\[(.+?)\]\]/)
      return label unless m

      link_elements = m[1].split('|', 2)
      link_elements.last
    end
  end
end
