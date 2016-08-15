require 'mumukit/bridge'
require 'active_support/all'

describe 'runner' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4569') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4569', err: '/dev/null'
    sleep 3
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'passes when the test covers all scenarios' do
    response = bridge.run_tests!(test: %q{
examples:
  - name: 'all ok'
    fixture: 'def f(x); x.abs; end'
    postconditions:
      status: passed
  - name: 'must test negative scenarios'
    fixture: 'def f(x); x; end'
    postconditions:
      status: failed
  - name: 'must test random scenarios'
    fixture: 'def f(_x); 4; end'
    postconditions:
      status: failed
}, extra: '', content: %q{
  describe 'f' do
    it { f(4).must_equal 4 }
    it { f(0).must_equal 0 }
    it { f(-5).must_equal 5 }
  end
}, expectations: [])
    expect(response).to eq response_type: :structured,
                           test_results: [
                               {title: 'all ok', status: :passed, result: nil},
                               {title: 'must test negative scenarios', status: :passed, result: nil},
                               {title: 'must test random scenarios', status: :passed, result: nil}],
                           status: :passed,
                           feedback: '',
                           expectation_results: [],
                           result: ''
  end

  it 'fails when test does not cover all scenarios' do
    response = bridge.run_tests!(test: %q{
examples:
  - name: 'all ok'
    fixture: 'def f(x); x.abs; end'
    postconditions:
      status: passed
  - name: 'must test negative scenarios'
    fixture: 'def f(x); x; end'
    postconditions:
      status: failed
  - name: 'must test random scenarios'
    fixture: 'def f(_x); 4; end'
    postconditions:
      status: failed
}, extra: '', content: %q{
  describe 'f' do
    it { f(4).must_equal 4 }
    it { f(0).must_equal 0 }
  end
}, expectations: [])
    expect(response).to eq response_type: :structured,
                           test_results: [
                               {title: 'all ok', status: :passed, result: nil},
                               {title: 'must test negative scenarios', status: :failed, result: 'tests should have failed, but passed'},
                               {title: 'must test random scenarios', status: :passed, result: nil}],
                           status: :failed,
                           feedback: '',
                           expectation_results: [],
                           result: ''
  end

  it 'failed when the test is wrong' do
    response = bridge.run_tests!(test: %q{
examples:
  - name: 'all ok'
    fixture: 'def f(x); x.abs; end'
    postconditions:
      status: passed
  - name: 'must test negative scenarios'
    fixture: 'def f(x); x; end'
    postconditions:
      status: failed
  - name: 'must test random scenarios'
    fixture: 'def f(_x); 4; end'
    postconditions:
      status: failed
}, extra: '', content: %q{
  describe 'f' do
    it { f(4).must_equal -4 }
    it { f(0).must_equal 0 }
    it { f(-5).must_equal 5 }
  end
}, expectations: [])
    expect(response).to eq response_type: :structured,
                           test_results: [
                               {title: 'all ok', status: :failed, result: 'tests should have passed, but failed'},
                               {title: 'must test negative scenarios', status: :passed, result: nil},
                               {title: 'must test random scenarios', status: :passed, result: nil}],
                           status: :failed,
                           feedback: '',
                           expectation_results: [],
                           result: ''
  end

end
