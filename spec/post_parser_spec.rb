require_relative 'spec_helper'

RSpec.describe PostParser do
  let(:post) { Post.new(fixture('post.yml')) }
  describe 'find_price' do
    #think works? left half done
    it 'tets' do
      p post
      p post.last_message_at.class
    end
  end

end
