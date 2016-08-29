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

  describe '#description_no_html' do
    it 'contains no javascript' do
      post.description = "<blockquote class=\"messageText SelectQuoteContainer ugc baseHtml\">\n\t\t\t\t\t\n\t\t\t\t\tVendido<br><div align=\"right\">\n<!-- /5920968/FMTB_300x250_DentroMensaje -->\n<div id=\"div-gpt-ad-1458127833989-1\" style=\"height:250px; width:300px;\">\n<script type=\"text/javascript\">\ngoogletag.cmd.push(function() { googletag.display('div-gpt-ad-1458127833989-1'); });\n</script>\n</div>\n</div>\n\t\t\t\t\t<div class=\"messageTextEndMarker\"> </div>\n\t\t\t\t</blockquote>"
      expect(post.description_no_html).not_to include 'googletag'
    end

  end
end
