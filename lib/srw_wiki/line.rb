module SrwWiki
  class Line
    SUMMARY_PATTERN = /\A\*\s*([^*].*)/
    LIST_ITEM_PATTERN = /\A\*{2}\s*([^*].*)/

    def self.from_lines(lines)
      next_lines = lines.drop(1)
      lines.
        zip(next_lines).
        map { |current_line, next_line| new(current_line, next_line) }
    end

    attr_reader :content
    attr_reader :label
    attr_reader :value

    def initialize(line, next_line)
      @content = line
      @label = nil
      @value = nil
      @summary = false
      @list_item = false

      case
      when m_summary = line.match(SUMMARY_PATTERN)
        @summary = true
        @label, @value = m_summary[1].split(/:|：/, 2)
        @value ||= ''
      when m_list_item = line.match(LIST_ITEM_PATTERN)
        @list_item = true
        @value = m_list_item[1]
      end

      @is_next_list_item = (LIST_ITEM_PATTERN === next_line)
    end

    def summary?
      @summary
    end

    def list_item?
      @list_item
    end

    def is_next_list_item?
      @is_next_list_item
    end
  end
end
