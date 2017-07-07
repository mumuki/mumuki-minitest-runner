class MinitestMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'minitest',
        icon: {type: 'devicon', name: 'ruby'},
        version: 'minitest-5.9.0/ruby-2.1',
        extension: 'rb',
        ace_mode: 'ruby'
    },
     test_framework: {
         name: 'minitest-metatest',
         test_extension: 'yml'
     }}
  end
end
