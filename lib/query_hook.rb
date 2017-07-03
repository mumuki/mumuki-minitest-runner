require 'yaml'
class MinitestQueryHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '_test.yml'
  end

  def compile_file_content(request)
    "require 'minitest/autorun'\n#{request.extra}\n#{request.content}"
  end

  def command_line(filename)
    "ruby #{filename} --seed 0 2>&1"
  end

  def post_process_file(file, result, status)
    if result =~ /^.+\n\n(# Running\:\n\n.+?\n\n).+?\n\n(.+)$/m
      [Mumukit::OutputFormatter.hide_tempfile_references("#{$1}#{$2}", tempfile_extension), status]
    else
      super
    end
  end
end


module Mumukit::OutputFormatter
  def self.hide_tempfile_references(code, suffix)
    code.gsub(/\/tmp\/mumuki\.compile(.*)#{suffix}/, "mumuki#{suffix}")
  end
end
