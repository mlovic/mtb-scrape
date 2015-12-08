require_relative 'spec_helper'

RSpec.describe PostParser do
  let(:post) { Post.new(fixture('post.yml')) }
  describe '.parse' do
    # think works? left half done
    it 'finds frame_only' do
      expect(PostParser.parse(post)[:frame_only]).to be true
      post.title = 'Santa Cruz v10'
      expect(PostParser.parse(post)[:frame_only]).not_to be true
    end

    it 'finds size' do
      expect(PostParser.parse(post)[:size]).to eq 'l'
      post.description = 'Santa Cruz v10 talla S'
      expect(PostParser.parse(post)[:size]).to eq 's'
    end

    it 'finds buyer' do
      pending 'changed to accomodate Dynatable'
      # figure this out
      #expect(PostParser.parse(post)[:seller]).to be false
      post.title = 'Busco Santa Cruz v10'
      expect(PostParser.parse(post)[:seller]).to be false
      post.title = 'compro Santa Cruz v10 '
      expect(PostParser.parse(post)[:seller]).to be false
    end

    it 'returns Hash of attributes' do
      expect(PostParser.parse(post).keys).to eq [:price, :brand, :model, :size, :frame_only, :uri, :thread_id]
    end

  end

end
