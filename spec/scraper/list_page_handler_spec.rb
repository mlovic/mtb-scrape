require 'spec_helper'
require 'scraper/list_page_handler'
require_relative '../factories'
require 'scraper/post_preview'

RSpec.describe ListPageHandler do
  before(:all) do
    doc = Nokogiri::HTML::Document.parse(fixture('post_preview.html'))
    @post_preview = doc.at('li').extend(PostPreview)
    @post_preview.freeze
  end

  let(:download_queue) { Array.new } # impl uses Queue. Double must impl <</push.
  let(:pp_handler) { double("pp_handler", add_post_preview: nil) }
  let(:lp_handler) { ListPageHandler.new(download_queue, pp_handler)  }

  describe '#eval_post' do
    let(:preview) do
      # Will raise error when PostPreview interface breaks
      object_double(@post_preview, title: 'mondraker', last_message_at: Time.now, 
                                   thread_id: 1234, url: 'url here')
    end

    context 'when post is new' do
      it 'the url is queued for download' do
        lp_handler.eval_post(preview)
        expect(download_queue.first.first).to eq 'url here'
      end

      it 'it is added to pp_handler cache' do
        expect(pp_handler).to receive(:add_post_preview).with('url here', preview)
        lp_handler.eval_post(preview)
      end
    end

    # TODO add post prev dep and use verifying double
    context 'when post is already in db' do
      before do 
        create(:post, title: 'mondraker', thread_id: 1234, last_message_at: (Time.now - 60*20))
      end

      context 'when post title has not changed' do
        before { allow(preview).to receive(:last_message_at).and_return(Time.now) }

        it 'updates last_message_at' do
          lp_handler.eval_post(preview)
          expect(Post.take.last_message_at).to be_within(1).of Time.now.utc
        end
      end

      context 'when post title has changed and looks closed' do
        before { allow(preview).to receive(:title).and_return('vendida') }

        it 'marks post as closed' do
          lp_handler.eval_post(preview)
          expect(Post.take).to be_closed
        end

        it 'updates last_message_at' do
          lp_handler.eval_post(preview)
          expect(Post.take.last_message_at).to be_within(1).of Time.now.utc
        end

        it 'does not change title' do
          lp_handler.eval_post(preview)
          expect(Post.take.title).to eq 'mondraker'
        end
      end

      # TODO use before(:all) and then run DBCleaner only once
      context 'when post title has changed and does not look closed' do
        before { allow(preview).to receive(:title).and_return('mondraker rebajada')}

        it 'does not mark as closed' do
          lp_handler.eval_post(preview)
          expect(Post.take).to_not be_closed
        end

        it 'updates post with new attributes' do
          lp_handler.eval_post(preview)
          expect(preview.title).to eq 'mondraker rebajada'
        end
      end
    end
  end
end
