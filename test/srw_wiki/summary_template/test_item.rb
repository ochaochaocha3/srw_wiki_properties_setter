require 'test/unit'
require 'srw_wiki/summary_template/item'

module SrwWiki
  module SummaryTemplate
    class ItemTest < Test::Unit::TestCase
      TEST_DATA = {
        '読み' => {
          label: '読み',
          data: '読み',
          parsed: '読み',
          wiki_text1: <<EOS.chomp,
| label1 = 読み
| data1 = {{{読み|}}}
EOS
          wiki_text10: <<EOS.chomp
| label10 = 読み
| data10 = {{{読み|}}}
EOS
        },
        '声優' => {
          label: '[[声優]]',
          data: '声優',
          parsed: ['声優', '[[声優]]'],
          wiki_text1: <<EOS.chomp,
| label1 = [[声優]]
| data1 = {{{声優|}}}
EOS
          wiki_text10: <<EOS.chomp
| label10 = [[声優]]
| data10 = {{{声優|}}}
EOS
        }
      }

      data(TEST_DATA)
      test '正しく初期化される' do |data|
        label = data[:label]
        data_str = data[:data]
        item = Item.new(label, data_str)

        assert_equal(label, item.label)
        assert_equal(data_str, item.data)
      end

      sub_test_case 'YAMLファイルを解析して得られた値からの変換' do
        data(TEST_DATA)
        test '正しく変換される' do |data|
          item = Item.from_parsed(data[:parsed])

          assert_equal(data[:label], item.label)
          assert_equal(data[:data], item.data)
        end

        test '型が異なる場合に例外が発生する' do
          assert_raise(TypeError) do
            Item.from_parsed(false)
          end

          assert_raise(TypeError) do
            Item.from_parsed(nil)
          end

          assert_raise(TypeError) do
            Item.from_parsed(1234)
          end

          assert_raise(TypeError) do
            Item.from_parsed([nil, '読み'])
          end

          assert_raise(TypeError) do
            Item.from_parsed(['読み'])
          end
        end
      end

      sub_test_case 'ウィキテキストへの変換' do
        data(TEST_DATA)
        test '1番に正しく変換できる' do |data|
          item = Item.new(data[:label], data[:data])
          assert_equal(data[:wiki_text1], item.to_wiki_text(1))
        end

        data(TEST_DATA)
        test '10番に正しく変換できる' do |data|
          item = Item.new(data[:label], data[:data])
          assert_equal(data[:wiki_text10], item.to_wiki_text(10))
        end
      end
    end
  end
end
