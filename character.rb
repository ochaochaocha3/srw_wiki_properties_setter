lib_dir = File.expand_path('lib', File.dirname(__FILE__))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'srw_wiki/character_property_setter'

puts(SrwWiki::CharacterPropertySetter.execute(ARGF.read))
