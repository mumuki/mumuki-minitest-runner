require 'mumukit/bridge'
require 'active_support/all'

describe 'runner' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4569') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4569', err: '/dev/null'
    sleep 3
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'allows to meta-test' do
    response = bridge.run_tests!(test: %q{
examples:
  - name: 'all ok'
    fixture: 'def f(x); x.abs; end'
    postconditions:
      - status: passed
  - name: 'must test negative scenarios'
    fixture: 'def f(x); x; end'
    postconditions:
      - status: failed
  - name: 'must test random scenarios'
    fixture: 'def f(_x); 4; end'
    postconditions:
      status: failed
}, extra: '', content: %q{
  describe 'f' do
    it { expect(f(4)).to eq 4 }
    it { expect(f(0)).to eq 0 }
    it { expect(f(-5)).to eq 5 }
  end
}, expectations: [])
    expect(response).to eq response_type: :structured,
                           test_results: [],
                           status: :passed,
                           feedback: '',
                           expectation_results: [],
                           result: "ok"
  end

end
