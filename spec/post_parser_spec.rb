require_relative '../lib/post_parser'
require_relative 'helpers'

include Helpers 

def strip_html(str)
  require 'nokogiri'
  doc = Nokogiri::HTML(str)
  doc.xpath("//script").remove
  doc.text
end

class ModelFinder
end

RSpec.describe PostParser do
  let(:post) do 
    description = fixture("post_description")
    double("post", 
            title: "USADO (REBAJADO)CUADRO MONDRAKER FOXY RR+TALAS 36 RC2",
            description_no_html: strip_html(description))
  end

  before(:each) do
    p_finder = double("price_finder", find_price: nil)
    m_finder = double("model_finder", get_model: nil, get_brand: nil)
    allow(PriceFinder).to receive(:new).and_return(p_finder)
    allow(ModelFinder).to receive(:new).and_return(m_finder)
  end

  describe 'finds size when format is:' do
    it 'talla S' do
      expect(PostParser.parse(post)[:size]).to eq 'L'
    end

    it 'talla s (lowercase)' do
      allow(post).to receive(:description_no_html).and_return 'Santa Cruz v10 talla xs'
      expect(PostParser.parse(post)[:size]).to eq 'XS'
    end

    it 't-S' do
      allow(post).to receive(:description_no_html).and_return 'Santa Cruz v10 t-S rebajada'
      expect(PostParser.parse(post)[:size]).to eq 'S'
    end

    it '(S)' do
      allow(post).to receive(:description_no_html).and_return 'Santa Cruz v10 (L) casi nueva'
      expect(PostParser.parse(post)[:size]).to eq 'L'
    end
  end

  it 'finds frame_only' do
    expect(PostParser.parse(post)[:frame_only]).to be true
    allow(post).to receive(:title).and_return 'Santa Cruz v10'
    expect(PostParser.parse(post)[:frame_only]).not_to be true
  end

  it 'finds is_sold' do
    expect(PostParser.parse(post)[:is_sold]).to eq false
    allow(post).to receive(:title).and_return 'Vendida!! - Santa Cruz v10 talla xs'
    expect(PostParser.parse(post)[:is_sold]).to eq true
  end

  it 'finds buyer' do
    allow(post).to receive(:title).and_return 'Busco Santa Cruz v10'
    expect(PostParser.parse(post)[:buyer]).to be true
    allow(post).to receive(:title).and_return 'compro Santa Cruz v10 '
    expect(PostParser.parse(post)[:buyer]).to be true
  end

  #it 'returns only attributes needed for bike' do
  #end

end
