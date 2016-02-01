require_relative 'spec_helper'

RSpec.describe Post do
  let(:post) { build(:post) }
  describe '#time_since_last_message' do
    # TODO bring time-sensitive from other proj
    it 'returns correct time' do
      pending
      expect(post.time_since_last_message).to eq 343
    end
  end
end
