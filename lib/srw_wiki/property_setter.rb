require 'strscan'
require 'stringio'

module SrwWiki
  class PropertySetter
    def self.simple_setter(name, format)
      lambda {
        _simple_setter = lambda { |value, is_next_list_item|
          ss = StringScanner.new(value)
          result = ''

          until ss.eos?
            case
            when ss.scan(%r![^&＆()（）+,，、.．。・/／:：;；<>＜＞\[\]［］【】{}｛｝←→⇐⇒]+!)
              result << format % [name, ss[0]]
            when ss.scan(/\(.+?\)|（.+?）|<.+?>|＜.+?＞|\[.+?\]|［.+?］|【.+?】|\{.+?\}|｛.+?｝/)
              result << ss[0]
            else
              result << ss.getch
            end
          end

          [result, _simple_setter]
        }
      }.call
    end

    # [[name::value]] 形式でプロパティを設定するセッターを返す
    # @param [String] name プロパティ名
    # @return [Proc]
    def self.simple_property_setter(name)
      simple_setter(name, '[[%s::%s]]')
    end

    # {{ name|value }} 形式でテンプレートを設定するセッターを返す
    # @param [String] name テンプレート名
    # @return [Proc]
    def self.simple_template_setter(name)
      simple_setter(name, '{{%s|%s}}')
    end

    # 単位付きプロパティを設定するセッターを返す
    # @param [String] name プロパティ名
    # @return [Proc]
    def self.property_with_unit_setter(name)
      lambda {
        _property_with_unit_setter = lambda { |value, is_next_list_item|
          [value.gsub(/([\d.]+)\s*([\wぁ-んァ-ヶ]+)/) { "[[#{name}::#{$1} #{$2}]]" },
           _property_with_unit_setter]
        }
      }.call
    end

    # リンクを置換するセッターを返す
    # @param [String] format 書式。%s を 1 つ入れること
    # @return [Proc]
    def self.link_replacer(format)
      lambda {
        _link_replacer = lambda { |value, is_next_list_item|
          [value.gsub(/\[\[(.+?)\]\]/) { format % $1 },  _link_replacer]
        }
      }.call
    end

    def self.link_to_property(name)
      link_replacer("[[#{name}::%s]]")
    end

    def self.link_to_template(name)
      link_replacer("{{#{name}|%s}}")
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

    def self.execute(source)
      lines = Line.from_lines(source.lines.map(&:chomp))

      list_setter = nil
      modified_lines = lines.map do |line|
        case
        when line.summary?
          label_without_link = remove_link(line.label)

          if setter = self::TEMPLATE_SETTER[label_without_link]
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
