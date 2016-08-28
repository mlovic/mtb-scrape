require_relative 'spec_helper'

RSpec.describe PriceFinder do
  it 'test' do
    post = build(:post)
    finder = PriceFinder.new(post.title, post.description)
    expect(finder.find_price).to eq 1250
  end

  it 'another test' do
    post = build(:post)
    post.title = 'vendo por 1000e bici que costaba 2000 euros'
    finder = PriceFinder.new(post.title, post.description)
    expect(finder.find_price).to eq 1000
  end

  it 'with thousands place point' do
    finder = PriceFinder.new('no price', 'La compre por 3.000e')
    expect(finder.find_price).to eq 3000
  end

  it 'no euro symbol' do
    pending
    finder = PriceFinder.new('Vendo bici por 2400', 'no desc')
    expect(finder.find_price).to eq 2400
  end

  it 'con mejoras REBAJADA 1990euros!!!' do
    finder = PriceFinder.new('Froggy 721 con mejoras REBAJADA 1990euros!!!', 'no desc')
    expect(finder.find_price).to eq 1990 
  end

  describe 'priority regexes' do
    it 'la vendo por' do
      finder = PriceFinder.new('no price', 'La compre por 3000e, la vendo por 1700')
      expect(finder.find_price).to eq 1700
    end

    it 'ahora' do
      finder = PriceFinder.new('no price', 'La vendia por 2400e, ahora por 2100')
      expect(finder.find_price).to eq 2100
    end

    it 'precio final' do
      finder = PriceFinder.new('no price', 'La vendia pr 2400e, precio final: 2100')
      expect(finder.find_price).to eq 2100
    end

    it 'nuevo precio' do
      finder = PriceFinder.new('no price', 'Antes 2400e, nuevo precio: 2100€')
      expect(finder.find_price).to eq 2100
    end
  end

  it 'extra test cases' do
    ['2300e la rebajo a 2100',
     '1900e, rebajado a 2100',
     'rebajado a 2100, desde 2400e',
     'La vendia por 900e, ahora €2100',
     'comprada por 1800 ... Precio: 2100 E'
    ].each do |str|
      finder = PriceFinder.new('no price', str)
      expect(finder.find_price).to eq 2100
    end
  end

  #it 'filters by credible vals' do
  #end

end
