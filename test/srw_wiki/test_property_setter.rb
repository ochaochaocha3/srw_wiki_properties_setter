require 'test/unit'
require 'srw_wiki/property_setter'

module SrwWiki
  class PropertySetterTest < Test::Unit::TestCase
    data(
      '通常' => {
        source: 'フューリー',
        expected: '[[種族::フューリー]]'
      },
      '複数' => {
        source: 'フューリー、地球人',
        expected: '[[種族::フューリー]]、[[種族::地球人]]'
      },
      '複数＋注記' => {
        source: 'フューリー、地球人（日本）',
        expected: '[[種族::フューリー]]、[[種族::地球人]]（日本）'
      }
    )
    test 'simple_property_setter' do |data|
      setter = PropertySetter.simple_property_setter('種族')
      modified, list_setter = setter[data[:source], false]

      assert_equal(data[:expected], modified)
      assert_same(setter, list_setter)
    end

    data(
      '通常' => {
        source: '声優A',
        expected: '{{声優|声優A}}'
      },
      '複数' => {
        source: '声優A、声優B',
        expected: '{{声優|声優A}}、{{声優|声優B}}'
      },
      '複数＋注記' => {
        source: '声優A、声優B（代役）',
        expected: '{{声優|声優A}}、{{声優|声優B}}（代役）'
      }
    )
    test 'simple_template_setter' do |data|
      setter = PropertySetter.simple_template_setter('声優')
      modified, list_setter = setter[data[:source], false]

      assert_equal(data[:expected], modified)
      assert_same(setter, list_setter)
    end

    data(
      '全長' => {
        setter: PropertySetter.property_with_unit_setter('全長'),
        source: '12.3 m',
        expected: '[[全長::12.3 m]]'
      },
      '重量' => {
        setter: PropertySetter.property_with_unit_setter('重量'),
        source: '45.6 t',
        expected: '[[重量::45.6 t]]'
      },
      '全長（空白なし）' => {
        setter: PropertySetter.property_with_unit_setter('全長'),
        source: '12.3m',
        expected: '[[全長::12.3 m]]'
      },
      '重量（空白なし）' => {
        setter: PropertySetter.property_with_unit_setter('重量'),
        source: '45.6t',
        expected: '[[重量::45.6 t]]'
      },
      '全長（注記：半角括弧）' => {
        setter: PropertySetter.property_with_unit_setter('全長'),
        source: '12.3 m(OG)',
        expected: '[[全長::12.3 m]](OG)'
      },
      '全長（注記：全角括弧）' => {
        setter: PropertySetter.property_with_unit_setter('全長'),
        source: '12.3 m（OG）',
        expected: '[[全長::12.3 m]]（OG）'
      },
      '全長（日本語単位）' => {
        setter: PropertySetter.property_with_unit_setter('全長'),
        source: '12.3 メット',
        expected: '[[全長::12.3 メット]]'
      },
      '全長（日本語単位＋注記）' => {
        setter: PropertySetter.property_with_unit_setter('全長'),
        source: '12.3 メット（ダンバイン）',
        expected: '[[全長::12.3 メット]]（ダンバイン）'
      }
    )
    test 'property_with_unit_setter' do |data|
      modified, list_setter = data[:setter][data[:source], false]

      assert_equal(data[:expected], modified)
      assert_same(data[:setter], list_setter)
    end

    test 'link_to_property' do
      setter = PropertySetter.link_to_property('搭乗機')
      modified, list_setter = setter['[[A]]→[[BCD]]', false]

      assert_equal('[[搭乗機::A]]→[[搭乗機::BCD]]', modified)
      assert_same(setter, list_setter)
    end

    test 'link_to_template' do
      setter = PropertySetter.link_to_template('所属 (人物)')
      modified, list_setter = setter['[[A]]→[[BCD]]', false]

      assert_equal('{{所属 (人物)|A}}→{{所属 (人物)|BCD}}', modified)
      assert_same(setter, list_setter)
    end
  end
end
