lib_dir = File.expand_path('../lib', File.dirname(__FILE__))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'srw_wiki/summary_template/generator'

generator = SrwWiki::SummaryTemplate::Generator.new(
  'character_summary.yml', 'summary_template.erb'
)
puts(generator.generate)
