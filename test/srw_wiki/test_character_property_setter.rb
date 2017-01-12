require 'test/unit'
require 'srw_wiki/character_property_setter'

module SrwWiki
  class CharacterPropertySetterTest < Test::Unit::TestCase
    # 登場人物概要テンプレートで包む
    # @return [String]
    def wrap_with_summary_template(content)
      "{{登場人物概要\n#{content.chomp}\n}}"
    end
    private :wrap_with_summary_template

    test '外国語表記' do
      assert_equal(wrap_with_summary_template('| 外国語表記 = [[外国語表記::Sänger Somvold]]'),
                   CharacterPropertySetter.execute('*外国語表記：Sänger Somvold'))
    end

    test '登場作品（1 つ）' do
      assert_equal(wrap_with_summary_template('| 登場作品 = {{登場作品 (人物)|マジンガーZ}}'),
                   CharacterPropertySetter.execute('*登場作品：[[マジンガーZ]]'))
    end

    test '登場作品（シリーズ）' do
      source = <<EOS
*[[登場作品]]：[[バンプレストオリジナル]]
**[[スーパーロボット大戦α外伝]]
**[[第2次スーパーロボット大戦α]]
EOS

      expected = wrap_with_summary_template(<<EOS)
| 登場作品 = [[バンプレストオリジナル]]
*{{登場作品 (人物)|スーパーロボット大戦α外伝}}
*{{登場作品 (人物)|第2次スーパーロボット大戦α}}
EOS
      assert_equal(expected,
                   CharacterPropertySetter.execute(source))
    end

    test '声優' do
      assert_equal(wrap_with_summary_template('| 声優 = {{声優|声優A}}'),
                   CharacterPropertySetter.execute('*[[声優]]：声優A'))
    end

    test '種族' do
      assert_equal(wrap_with_summary_template('| 種族 = [[種族::地球人]]（ドイツ系）'),
                   CharacterPropertySetter.execute('*種族：地球人（ドイツ系）'))
    end

    test '性別' do
      assert_equal(wrap_with_summary_template('| 性別 = [[性別::男]]'),
                   CharacterPropertySetter.execute('*性別：男'))
    end

    test '年齢' do
      assert_equal(wrap_with_summary_template('| 年齢 = [[年齢::29]]歳'),
                   CharacterPropertySetter.execute('*[[年齢]]：29歳'))
    end

    test '身長' do
      assert_equal(wrap_with_summary_template('| 身長 = [[身長::180 cm]]'),
                   CharacterPropertySetter.execute('*身長：180 cm'))
    end

    test '体重' do
      assert_equal(wrap_with_summary_template('| 体重 = [[体重::60 kg]]'),
                   CharacterPropertySetter.execute('*体重：60 kg'))
    end

    test '血液型' do
      assert_equal(wrap_with_summary_template('| 血液型 = [[血液型::B]]型'),
                   CharacterPropertySetter.execute('*血液型：B型'))
    end

    test '所属（1 つ）' do
      assert_equal(wrap_with_summary_template('| 所属 = {{所属 (人物)|地球連邦軍 (OG)|地球連邦軍}}'),
                   CharacterPropertySetter.execute('*所属：[[地球連邦軍 (OG)|地球連邦軍]]'))
    end

    test '所属（複数）' do
      source = <<EOS
*所属：
**[[ディバイン・クルセイダーズ]]→[[αナンバーズ]]（αシリーズ）
**[[地球連邦軍 (OG)|地球連邦軍]]（OGシリーズ）
EOS

      expected = wrap_with_summary_template(<<EOS)
| 所属 =
*{{所属 (人物)|ディバイン・クルセイダーズ}}→{{所属 (人物)|αナンバーズ}}（αシリーズ）
*{{所属 (人物)|地球連邦軍 (OG)|地球連邦軍}}（OGシリーズ）
EOS

      assert_equal(expected,
                   CharacterPropertySetter.execute(source))
    end

    test '所属（複数；コロンなし）' do
      source = <<EOS
*所属
**[[ディバイン・クルセイダーズ]]→[[αナンバーズ]]（αシリーズ）
**[[地球連邦軍 (OG)|地球連邦軍]]（OGシリーズ）
EOS

      expected = wrap_with_summary_template(<<EOS)
| 所属 =
*{{所属 (人物)|ディバイン・クルセイダーズ}}→{{所属 (人物)|αナンバーズ}}（αシリーズ）
*{{所属 (人物)|地球連邦軍 (OG)|地球連邦軍}}（OGシリーズ）
EOS

      assert_equal(expected,
                   CharacterPropertySetter.execute(source))
    end

    test '階級' do
      assert_equal(wrap_with_summary_template('| 階級 = [[階級::少尉]]'),
                   CharacterPropertySetter.execute('*階級：少尉'))
    end

    test '役職' do
      assert_equal(wrap_with_summary_template('| 役職 = [[役職::隊長]]'),
                   CharacterPropertySetter.execute('*役職：隊長'))
    end

    test '称号' do
      assert_equal(wrap_with_summary_template('| 称号 = [[称号::伝承者]]'),
                   CharacterPropertySetter.execute('*称号：伝承者'))
    end

    test '主な搭乗機' do
      assert_equal(wrap_with_summary_template('| 主な搭乗機 = [[搭乗機::ゲシュペンスト]]'),
                   CharacterPropertySetter.execute('*主な搭乗機：[[ゲシュペンスト]]'))
    end

    test 'キャラクターデザイン' do
      assert_equal(wrap_with_summary_template('| キャラクターデザイン = {{キャラクターデザイン|デザイナー}}'),
                   CharacterPropertySetter.execute('*キャラクターデザイン：デザイナー'))
    end

    test 'メカニックデザイン' do
      assert_equal(wrap_with_summary_template('| メカニックデザイン = {{メカニックデザイン|デザイナー}}'),
                   CharacterPropertySetter.execute('*メカニックデザイン：デザイナー'))
    end
  end
end
