require_relative 'spec_helper'

RSpec.describe Post do
  let(:post) { build(:post) }

  it 'does not include old posts by default' do
    post.save
    create(:post, is_old: true)
    expect(Post.count).to eq 1
    expect(Post.first.is_old).to eq false
  end

  describe '#time_since_last_message' do
    # TODO bring time-sensitive from other proj
    it 'returns correct time' do
      pending
      expect(post.time_since_last_message).to eq 343
    end
  end
end
