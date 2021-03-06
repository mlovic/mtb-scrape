require 'timecop'
require_relative 'spec_helper'
require_relative 'factories'
require_relative '../lib/post'

RSpec.describe Post, loads_DB: true do
  let(:post) { build(:post) }

  describe 'updated' do
    it 'includes posts that were updated more recently than corresponsing bike' do
      post.save
      bike = create(:bike, post_id: post.id)
      expect(Post.updated.count).to eq 0
      post.update(title: "New title!")
      expect(Post.updated.count).to eq 1
      bike.update(price: 2000) 
      expect(Post.updated.count).to eq 0
    end
  end

  describe 'on save' do
    it 'marks post as deleted if description is too short' do
      post = create(:post, description: "Vendida, gracias a todos")
      expect(post.deleted).to eq true
    end

    it 'marks post as closed if title contains sold keyword' do
      expect(post.closed).to_not eq true
      post.update(title: "Vendida")
      expect(post.closed).to eq true
    end

    it 'marks post as buyer if title contains keyword' do
      post = create(:post, title: "Busco cuadro dh")
      expect(post.buyer).to eq true
    end
  end

  it 'does not include old posts by default' do
    post.save
    create(:post, is_old: true)
    expect(Post.count).to eq 1
    expect(Post.first.is_old).to eq false
  end

  describe '#time_since_last_message' do

    it 'returns correct time' do
      post.last_message_at = Time.now

      Timecop.freeze(Time.now + 120) do
        expect(post.time_since_last_message.round).to eq 120
      end
    end
  end

  describe '#description_no_html' do

    it 'contains no javascript' do
      post.description = "<blockquote class=\"messageText SelectQuoteContainer ugc baseHtml\">\n\t\t\t\t\t\n\t\t\t\t\tVendido<br><div align=\"right\">\n<!-- /5920968/FMTB_300x250_DentroMensaje -->\n<div id=\"div-gpt-ad-1458127833989-1\" style=\"height:250px; width:300px;\">\n<script type=\"text/javascript\">\ngoogletag.cmd.push(function() { googletag.display('div-gpt-ad-1458127833989-1'); });\n</script>\n</div>\n</div>\n\t\t\t\t\t<div class=\"messageTextEndMarker\"> </div>\n\t\t\t\t</blockquote>"
      expect(post.description_no_html).not_to include 'googletag'
    end
  end
end
