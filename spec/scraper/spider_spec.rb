require 'thread'
require 'timeout'
require 'scraper/spider'

Thread.abort_on_exception = true

# move to Helpers?
def wait_until(timeout = 5, sleep_time = 0.01)
  Timeout::timeout(timeout) do # raises exception if timeout
    while !yield
      sleep sleep_time
    end
  end
end

RSpec.describe Spider do
  # TODO Are threads being killed when Spider goes out of scope?
  let(:spider) { Spider.new(agent, time_between_requests: 0) }
  let(:in_q)  { Queue.new }
  let(:out_q) { Queue.new }
  let(:agent) { double("agent") }

  describe '#kill!' do
    it 'kills internal thread' do
      thread = spider.crawl_async(in_q, out_q)
      expect(thread.alive?).to eq true
      spider.kill
      wait_until(0.1) { !thread.alive? }
      expect(thread.alive?).to eq false
    end

    it 'does nothing if there is no thread' do
      expect{ spider.kill }.to_not raise_error
    end
  end

  describe '#crawl_async' do
    it 'consumes download queue until input_queue is closed' do
      in_q.push(1)
      allow(agent).to receive(:get, &:itself)
      spider = Spider.new(agent, time_between_requests: 0)

      spider.crawl_async(in_q, out_q)
      wait_until { in_q.empty? }
      expect(out_q.pop).to eq [1, nil]

      in_q << 2
      wait_until { in_q.empty? }
      expect(out_q.pop).to eq [2, nil]
      in_q.close
    end

    it 'returns thread' do
      expect(spider.crawl_async(in_q, out_q)).to be_a Thread
    end

    it 'kills thread when input queue closes' do
      thread = spider.crawl_async(in_q, out_q)
      in_q.close
      wait_until(1) { !thread.alive? }
      expect(thread.alive?).to eq false
    end

    context 'Exception is raised' do
      it 'continues with next item from the queue' do
        in_q.push("good url").push("bad url").push("good url")
        allow(agent).to receive(:get).with("good url").and_return("success")
        allow(agent).to receive(:get).with("bad url").and_raise("Stub error")
        spider = Spider.new(agent, time_between_requests: 0)

        spider.crawl_async(in_q, out_q)
        wait_until { in_q.empty? }
        in_q.close
        expect(out_q.size).to eq 2
      end
    end
  end
end
