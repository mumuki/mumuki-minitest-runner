require 'yaml'
require 'mumukit'

class MinitestRunner
  include Mumukit::WithTempfile

  def run(compilation, example)
    spec = write_tempfile! "require 'minitest/autorun'\n#{compilation}\n#{example[:fixture]}"
    out = %x{ruby #{spec.path}}
    case $?.exitstatus
      when 0 then [out, :passed]
      else [out, :failed]
    end
  end

end

class MultitestChecker < Mumukit::Metatest::Checker
  def check_status(result, status)
    raise "tests should have #{status}, but #{result[1]}" unless result[1] == status.to_sym
  end

  def check_message(result, message)
    raise "expected message #{result[0]} to include #{message}" unless result[0].include message
  end
end

input = YAML.load_file(ARGV[0]).deep_symbolize_keys

framework = Mumukit::Metatest::Framework.new runner: MinitestRunner.new,
                                             checker: MultitestChecker.new
result = framework.test("#{input[:extra]}\n#{input[:content]}", input[:test][:examples])

puts ({results: result[0]}).to_json