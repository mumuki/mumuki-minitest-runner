require_relative './spec_helper'

describe MinitestQueryHook do
  let(:hook) { MinitestQueryHook.new }
  let(:result) { hook.run!(file) }
  let(:file) { hook.compile(request) }
  let(:request) { struct(content: content, query: query, extra: extra) }

  context 'when command line is ok' do
    context 'when test pass' do
      let(:content) { %q{               #1
  describe 'f' do                       #2
    it { assert_equal 4, f(4) }         #3
    it { assert_equal 0, f(0) }         #4
    it { assert_equal 5, f(-5) }        #5
  end                                   #6} }
      let(:extra) { 'def f(x) x.abs end' }
      let(:query) { 'rake test' }

      it { expect(result).to eq ["# Running:\n\n...\n\n3 runs, 3 assertions, 0 failures, 0 errors, 0 skips\n", :passed] }
    end



    context 'when test dont pass' do
      let(:content) { %q{               #1
  describe 'f' do                       #2
    it { assert_equal 4, f(4) }         #3
    it { assert_equal 2, f(0) }         #4
    it { assert_equal 5, f(-5) }        #5
  end                                   #6} }
      let(:extra) { "def f(x);\nx.abs\n end\n" }
      let(:query) { 'rake test' }

      it { expect(result).to eq ["# Running:\n\n.F.\n\n  1) Failure:\nf#test_0002_anonymous [solution_test.yml:4]:\nExpected: 2\n  Actual: 0\n\n3 runs, 3 assertions, 1 failures, 0 errors, 0 skips\n", :failed] }
    end
  end

  context 'when command line is not ok' do
    let(:content) { %q{
  describe 'f' do
    it { assert_equal 4, f(4) }
    it { assert_equal 0, f(0) }
    it { assert_equal 5, f(-5) }
  end} }

    let(:extra) { 'def f(x) x.abs end' }
    let(:query) { 'dsdsds' }

    it { expect { result }.to raise_error Mumukit::CompilationError }
  end

end

