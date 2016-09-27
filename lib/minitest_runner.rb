require 'mumukit'

Mumukit.runner_name = 'minitest'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-minitest-worker'
  config.comment_type = Mumukit::Directives::CommentType::Ruby
  config.structured = true
  config.stateful = false
end

require_relative './metadata_hook'
require_relative './test_hook'