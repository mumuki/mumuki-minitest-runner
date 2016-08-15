class MinitestMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'ruby',
        icon: {type: 'devicon', name: 'ruby'},
        version: '2.0',
        extension: 'rb',
        ace_mode: 'ruby'
    },
     test_framework: {
         name: 'minitest',
         version: '5.9.0',
         test_extension: '.yml'
     }}
  end
end