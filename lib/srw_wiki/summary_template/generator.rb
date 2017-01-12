require 'yaml'
require 'erubis'

require 'srw_wiki/summary_template/template'

module SrwWiki
  module SummaryTemplate
    # 概要テンプレートの生成器。
    class Generator
      # yaml_path 設定のYAMLファイルのパス
      # @return [String]
      attr_reader :yaml_path
      # テンプレートのERBファイルのパス
      # @return [String]
      attr_reader :erb_path

      # 概要テンプレート生成器を初期化する
      # @param [String] yaml_path 設定のYAMLファイルのパス
      # @param [String] erb_path テンプレートのERBファイルのパス
      def initialize(yaml_path, erb_path)
        @yaml_path = yaml_path
        @erb_path = erb_path
      end

      # 概要テンプレートを生成する
      # @return [String]
      def generate
        data = YAML.load_file(@yaml_path)
        template = Template.from_hash(data)

        input = File.read(@erb_path)
        erb = Erubis::Eruby.new(input)

        puts(erb.result(template: template))
      end
    end
  end
end
