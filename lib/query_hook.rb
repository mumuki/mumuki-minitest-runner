require 'yaml'
class MinitestQueryHook < Mumukit::Templates::FileHook
  isolated true
  line_number_offset 2, include_extra: true

  def tempfile_extension
    '_test.yml'
  end

  def compile_file_content(request)
    if request.query.strip != 'rake test'
      raise Mumukit::CompilationError, t(:unrecognized_command)
    end

    "require 'minitest/autorun'\n#{request.extra}\n#{request.content}"
  end

  def command_line(filename)
    "ruby #{filename} --seed 0 2>&1"
  end

  def post_process_file(file, result, status)
    if result =~ /^.+\n\n(# Running\:\n\n.+?\n\n).+?\n\n(.+)$/m
      ["#{$1}#{$2}", status]
    else
      super
    end
  end
end

