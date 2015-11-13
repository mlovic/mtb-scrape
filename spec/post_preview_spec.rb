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
  it 'is not sticky' do
    pp post_preview
    expect(post_preview).to respond_to :attributes
    expect(post_preview).to_not be_sticky
  end
end
