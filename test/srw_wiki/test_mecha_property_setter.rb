require 'test/unit'
require 'srw_wiki/mecha_property_setter'

module SrwWiki
  class MechaPropertySetterTest < Test::Unit::TestCase
    # 登場メカ概要テンプレートで包む
    # @return [String]
    def wrap_with_summary_template(content)
      "{{登場メカ概要\n#{content.chomp}\n}}"
    end
    private :wrap_with_summary_template

    test '外国語表記' do
      assert_equal(wrap_with_summary_template('| 外国語表記 = [[外国語表記::Gespenst]]'),
                   MechaPropertySetter.execute('*外国語表記：Gespenst'))
    end

    test '登場作品（1 つ）' do
      assert_equal(wrap_with_summary_template('| 登場作品 = {{登場作品 (メカ)|マジンガーZ}}'),
                   MechaPropertySetter.execute('*登場作品：[[マジンガーZ]]'))
    end

    test '登場作品（シリーズ）' do
      source = <<EOS
*[[登場作品]]：[[バンプレストオリジナル]]
**[[スーパーロボット大戦α外伝]]
**[[第2次スーパーロボット大戦α]]
EOS

      expected = wrap_with_summary_template(<<EOS)
| 登場作品 = [[バンプレストオリジナル]]
*{{登場作品 (メカ)|スーパーロボット大戦α外伝}}
*{{登場作品 (メカ)|第2次スーパーロボット大戦α}}
EOS
      assert_equal(expected,
                   MechaPropertySetter.execute(source))
    end

    test '声優' do
      assert_equal(wrap_with_summary_template('| 声優 = {{声優|声優A}}'),
                   MechaPropertySetter.execute('*[[声優]]：声優A'))
    end

    test '分類' do
      assert_equal(wrap_with_summary_template('| 分類 = [[分類::分類A]]'),
                   MechaPropertySetter.execute('*分類：[[分類A]]'))
    end

    test '型式番号' do
      assert_equal(wrap_with_summary_template('| 型式番号 = [[型式番号::XYZ-1]]'),
                   MechaPropertySetter.execute('*型式番号：XYZ-1'))
    end

    test '頭頂高' do
      assert_equal(wrap_with_summary_template('| 頭頂高 = [[頭頂高::12.3 m]]'),
                   MechaPropertySetter.execute('*頭頂高：12.3m'))
    end

    test '全高' do
      assert_equal(wrap_with_summary_template('| 全高 = [[全長::13.2 m]]'),
                   MechaPropertySetter.execute('*全高：13.2m'))
    end

    test '全長' do
      assert_equal(wrap_with_summary_template('| 全長 = [[全長::13.2 m]]'),
                   MechaPropertySetter.execute('*全長：13.2m'))
    end

    test '重量' do
      assert_equal(wrap_with_summary_template('| 重量 = [[重量::45.6 t]]'),
                   MechaPropertySetter.execute('*重量：45.6t'))
    end

    test '動力' do
      assert_equal(wrap_with_summary_template('| 動力 = [[動力::エンジンA]]'),
                   MechaPropertySetter.execute('*動力：エンジンA'))
    end

    test '出力' do
      assert_equal(wrap_with_summary_template('| 出力 = [[出力::1000 kW]]'),
                   MechaPropertySetter.execute('*出力：1000kW'))
    end

    test '推進機関' do
      assert_equal(wrap_with_summary_template('| 推進機関 = [[推進機関::エンジンA]]'),
                   MechaPropertySetter.execute('*推進機関：エンジンA'))
    end

    test '推力' do
      assert_equal(wrap_with_summary_template('| 推力 = [[推力::1000000 kgf]]'),
                   MechaPropertySetter.execute('*推力：1000000kgf'))
    end

    test '装甲材質' do
      assert_equal(wrap_with_summary_template('| 装甲材質 = [[装甲材質::合金A]]'),
                   MechaPropertySetter.execute('*装甲材質：合金A'))
    end

    test 'MMI' do
      assert_equal(wrap_with_summary_template('| MMI = [[MMI::MMI A]]'),
                   MechaPropertySetter.execute('*MMI：MMI A'))
    end

    test '開発' do
      assert_equal(wrap_with_summary_template('| 開発 = [[開発::開発者A]]'),
                   MechaPropertySetter.execute('*開発：[[開発者A]]'))
    end

    test '開発者' do
      assert_equal(wrap_with_summary_template('| 開発者 = [[開発::開発者A]]'),
                   MechaPropertySetter.execute('*開発者：[[開発者A]]'))
    end

    test '所属（1 つ）' do
      assert_equal(wrap_with_summary_template('| 所属 = {{所属 (メカ)|地球連邦軍 (OG)|地球連邦軍}}'),
                   MechaPropertySetter.execute('*所属：[[地球連邦軍 (OG)|地球連邦軍]]'))
    end

    test '所属（複数）' do
      source = <<EOS
*所属：
**[[ディバイン・クルセイダーズ]]→[[αナンバーズ]]（αシリーズ）
**[[地球連邦軍 (OG)|地球連邦軍]]（OGシリーズ）
EOS

      expected = wrap_with_summary_template(<<EOS)
| 所属 =
*{{所属 (メカ)|ディバイン・クルセイダーズ}}→{{所属 (メカ)|αナンバーズ}}（αシリーズ）
*{{所属 (メカ)|地球連邦軍 (OG)|地球連邦軍}}（OGシリーズ）
EOS

      assert_equal(expected,
                   MechaPropertySetter.execute(source))
    end

    test '所属（複数；コロンなし）' do
      source = <<EOS
*所属
**[[ディバイン・クルセイダーズ]]→[[αナンバーズ]]（αシリーズ）
**[[地球連邦軍 (OG)|地球連邦軍]]（OGシリーズ）
EOS

      expected = wrap_with_summary_template(<<EOS)
| 所属 =
*{{所属 (メカ)|ディバイン・クルセイダーズ}}→{{所属 (メカ)|αナンバーズ}}（αシリーズ）
*{{所属 (メカ)|地球連邦軍 (OG)|地球連邦軍}}（OGシリーズ）
EOS

      assert_equal(expected,
                   MechaPropertySetter.execute(source))
    end

    test '主なパイロット' do
      assert_equal(wrap_with_summary_template('| 主なパイロット = [[パイロット::パイロット]]'),
                   MechaPropertySetter.execute('*主なパイロット：[[パイロット]]'))
    end

    test 'キャラクターデザイン' do
      assert_equal(wrap_with_summary_template('| キャラクターデザイン = {{キャラクターデザイン|デザイナー}}'),
                   MechaPropertySetter.execute('*キャラクターデザイン：デザイナー'))
    end

    test 'メカニックデザイン' do
      assert_equal(wrap_with_summary_template('| メカニックデザイン = {{メカニックデザイン|デザイナー}}'),
                   MechaPropertySetter.execute('*メカニックデザイン：デザイナー'))
    end
  end
end
