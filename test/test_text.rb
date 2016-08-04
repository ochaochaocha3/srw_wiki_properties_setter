require 'test/unit'
require 'srw_wiki/character_property_setter'

class TextTest < Test::Unit::TestCase
  def test_saenger
    saenger = <<EOS.chomp
*外国語表記：Sänger Somvold
*[[登場作品]]：[[バンプレストオリジナル]]
**[[スーパーロボット大戦α外伝]]
**[[第2次スーパーロボット大戦α]]
*[[声優]]：小野健一
*種族：地球人（ドイツ系）
*性別：男
*[[年齢]]：29歳（αシリーズ。第2次OGの時点では30代に突入していると思われる）
*生年月日：1月5日
*血液型：B型
*髪色：銀髪（α外伝では紫）
*所属：
**[[ディバイン・クルセイダーズ]]→[[αナンバーズ]]（αシリーズ）
**[[地球連邦軍 (OG)|地球連邦軍]]（[[特殊戦技教導隊]]→[[ATXチーム]]）→[[ディバイン・クルセイダーズ]]・[[コロニー統合軍]]→[[クロガネ隊]]（OGシリーズ）
*[[軍階級|階級]]：少佐
*好きなもの：ブラックコーヒー
*趣味：釣り
*キャラクターデザイン：河野さち子
EOS

    expected = <<EOS.chomp
*外国語表記：[[外国語表記::Sänger Somvold]]
*[[登場作品]]：[[バンプレストオリジナル]]
**{{登場作品 (人物)|スーパーロボット大戦α外伝}}
**{{登場作品 (人物)|第2次スーパーロボット大戦α}}
*[[声優]]：{{声優|小野健一}}
*種族：[[種族::地球人]]（ドイツ系）
*性別：[[性別::男]]
*[[年齢]]：[[年齢::29]]歳（αシリーズ。第2次OGの時点では30代に突入していると思われる）
*生年月日：1月5日
*血液型：[[血液型::B]]型
*髪色：銀髪（α外伝では紫）
*所属：
**{{所属 (人物)|ディバイン・クルセイダーズ}}→{{所属 (人物)|αナンバーズ}}（αシリーズ）
**{{所属 (人物)|地球連邦軍 (OG)|地球連邦軍}}（{{所属 (人物)|特殊戦技教導隊}}→{{所属 (人物)|ATXチーム}}）→{{所属 (人物)|ディバイン・クルセイダーズ}}・{{所属 (人物)|コロニー統合軍}}→{{所属 (人物)|クロガネ隊}}（OGシリーズ）
*[[軍階級|階級]]：[[階級::少佐]]
*好きなもの：ブラックコーヒー
*趣味：釣り
*キャラクターデザイン：{{キャラクターデザイン|河野さち子}}
EOS

    assert_equal(expected, SrwWiki::CharacterPropertySetter.execute(saenger))
  end
end
