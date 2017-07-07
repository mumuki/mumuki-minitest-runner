require 'mumukit'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'minitest'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-minitest-worker'
  config.comment_type = Mumukit::Directives::CommentType::Ruby
  config.structured = true
  config.stateful = false
end

require_relative './version'
require_relative './metadata_hook'
require_relative './query_hook'
require_relative './test_hook'
