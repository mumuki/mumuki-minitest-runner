require 'yaml'
class MinitestTestHook < Mumukit::Templates::FileHook
  isolated true
  structured true

  def tempfile_extension
    '.yml'
  end

  def compile_file_content(request)
    r = {'test' => YAML.load(request.test),
     'extra' => request.extra,
     'content' => request.content}.to_yaml
    puts r
    r
  end

  def command_line(filename)
    "ruby multitest.rb #{filename} 2>&1"
  end

  def to_structured_result(result)
    super['results']
  end
end
