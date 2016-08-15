require 'test/unit'
require 'srw_wiki/mecha_property_setter'

module SrwWiki
  class MechaPropertySetterTest < Test::Unit::TestCase
    test '外国語表記' do
      assert_equal('*外国語表記：[[外国語表記::Gespenst]]',
                   MechaPropertySetter.execute('*外国語表記：Gespenst'))
    end

    test '登場作品（1 つ）' do
      assert_equal('*登場作品：{{登場作品 (メカ)|マジンガーZ}}',
                   MechaPropertySetter.execute('*登場作品：[[マジンガーZ]]'))
    end

    test '登場作品（シリーズ）' do
      source = <<EOS
*[[登場作品]]：[[バンプレストオリジナル]]
**[[スーパーロボット大戦α外伝]]
**[[第2次スーパーロボット大戦α]]
EOS

      expected = <<EOS.chomp
*[[登場作品]]：[[バンプレストオリジナル]]
**{{登場作品 (メカ)|スーパーロボット大戦α外伝}}
**{{登場作品 (メカ)|第2次スーパーロボット大戦α}}
EOS
      assert_equal(expected,
                   MechaPropertySetter.execute(source))
    end

    test '声優' do
      assert_equal('*[[声優]]：{{声優|声優A}}',
                   MechaPropertySetter.execute('*[[声優]]：声優A'))
    end

    test '分類' do
      assert_equal('*分類：[[分類::分類A]]',
                   MechaPropertySetter.execute('*分類：[[分類A]]'))
    end

    test '型式番号' do
      assert_equal('*型式番号：[[型式番号::XYZ-1]]',
                   MechaPropertySetter.execute('*型式番号：XYZ-1'))
    end

    test '頭頂高' do
      assert_equal('*頭頂高：[[頭頂高::12.3 m]]',
                   MechaPropertySetter.execute('*頭頂高：12.3m'))
    end

    test '全高' do
      assert_equal('*全高：[[全長::13.2 m]]',
                   MechaPropertySetter.execute('*全高：13.2m'))
    end

    test '全長' do
      assert_equal('*全長：[[全長::13.2 m]]',
                   MechaPropertySetter.execute('*全長：13.2m'))
    end

    test '重量' do
      assert_equal('*重量：[[重量::45.6 t]]',
                   MechaPropertySetter.execute('*重量：45.6t'))
    end

    test '動力' do
      assert_equal('*動力：[[動力::エンジンA]]',
                   MechaPropertySetter.execute('*動力：エンジンA'))
    end

    test '出力' do
      assert_equal('*出力：[[出力::1000 kW]]',
                   MechaPropertySetter.execute('*出力：1000kW'))
    end

    test '推進機関' do
      assert_equal('*推進機関：[[推進機関::エンジンA]]',
                   MechaPropertySetter.execute('*推進機関：エンジンA'))
    end

    test '推力' do
      assert_equal('*推力：[[推力::1000000 kgf]]',
                   MechaPropertySetter.execute('*推力：1000000kgf'))
    end

    test '装甲材質' do
      assert_equal('*装甲材質：[[装甲材質::合金A]]',
                   MechaPropertySetter.execute('*装甲材質：合金A'))
    end

    test 'MMI' do
      assert_equal('*MMI：[[MMI::MMI A]]',
                   MechaPropertySetter.execute('*MMI：MMI A'))
    end

    test '開発' do
      assert_equal('*開発：[[開発::開発者A]]',
                   MechaPropertySetter.execute('*開発：[[開発者A]]'))
    end

    test '開発者' do
      assert_equal('*開発者：[[開発::開発者A]]',
                   MechaPropertySetter.execute('*開発者：[[開発者A]]'))
    end

    test '所属（1 つ）' do
      assert_equal('*所属：{{所属 (メカ)|地球連邦軍 (OG)|地球連邦軍}}',
                   MechaPropertySetter.execute('*所属：[[地球連邦軍 (OG)|地球連邦軍]]'))
    end

    test '所属（複数）' do
      source = <<EOS
*所属：
**[[ディバイン・クルセイダーズ]]→[[αナンバーズ]]（αシリーズ）
**[[地球連邦軍 (OG)|地球連邦軍]]（OGシリーズ）
EOS

      expected = <<EOS.chomp
*所属：
**{{所属 (メカ)|ディバイン・クルセイダーズ}}→{{所属 (メカ)|αナンバーズ}}（αシリーズ）
**{{所属 (メカ)|地球連邦軍 (OG)|地球連邦軍}}（OGシリーズ）
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

      expected = <<EOS.chomp
*所属：
**{{所属 (メカ)|ディバイン・クルセイダーズ}}→{{所属 (メカ)|αナンバーズ}}（αシリーズ）
**{{所属 (メカ)|地球連邦軍 (OG)|地球連邦軍}}（OGシリーズ）
EOS

      assert_equal(expected,
                   MechaPropertySetter.execute(source))
    end

    test '主なパイロット' do
      assert_equal('*主なパイロット：[[パイロット::パイロット]]',
                   MechaPropertySetter.execute('*主なパイロット：[[パイロット]]'))
    end

    test 'キャラクターデザイン' do
      assert_equal('*キャラクターデザイン：{{キャラクターデザイン|デザイナー}}',
                   MechaPropertySetter.execute('*キャラクターデザイン：デザイナー'))
    end

    test 'メカニックデザイン' do
      assert_equal('*メカニックデザイン：{{メカニックデザイン|デザイナー}}',
                   MechaPropertySetter.execute('*メカニックデザイン：デザイナー'))
    end
  end
end
