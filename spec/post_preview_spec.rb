require_relative 'spec_helper'

RSpec.describe PostPreview do
  let(:post_preview) { 
    doc = Nokogiri::HTML::Document.parse(fixture('post_preview.html'))
    doc.at('li').extend PostPreview
    # think of better way to do this. Maube Node.new.content = str
    #
    # real class uses element, test uses document. Both inherit from node, 
    #   which is what matters appartently
  }
  let(:sticky_post_preview) {
    doc = Nokogiri::HTML::Document.parse(fixture('sticky_post_preview.html'))
    doc.at('li').extend PostPreview
  }

  describe '#sticky' do
    it 'returns true when post is sticky' do
      expect(sticky_post_preview).to be_sticky
    end
    it 'returns false when post is not sticky' do
      expect(post_preview).to_not be_sticky
    end
  end

  describe '#thread_id' do
    it 'returns thread id' do
      expect(post_preview.thread_id).to eq 1281012
    end
    # raise error if no thread id found?
    # special error for no found
  end

  describe '#last_message_at' do
    it 'returns time of last thread message' do
      expect(post_preview.last_message_at).to eq DateTime.parse('11 Nov 2015 07:29:28 +01:00')
    end
  end

  describe 'title' do
    it 'returns post title' do
      expect(post_preview.title).to eq 'Santa cruz driver 8'
    end
  end

end
