require 'parser/price_finder'

RSpec.describe PriceFinder do

  it 'with thousands place point' do
    finder = PriceFinder.new('no price', 'La compre por 3.000e')
    expect(finder.find_price).to eq 3000
  end

  it 'no euro symbol' do
    # TODO 
    pending "this rule could be conflictive"
    finder = PriceFinder.new('Vendo bici por 2400', 'no desc')
    expect(finder.find_price).to eq 2400
  end

  it 'con mejoras REBAJADA 1990euros!!!' do
    finder = PriceFinder.new('Froggy 721 con mejoras REBAJADA 1990euros!!!', 'no desc')
    expect(finder.find_price).to eq 1990 
  end

  it 'la bici fue mas de 8000 euros. Precio 3.500' do
    finder = PriceFinder.new('', 'la bici fue mas de 8000 euros. Precio 3.500')
    expect(finder.find_price).to eq 3500
  end

  it 'distinguishes between frame and bike'

  describe 'preferences' do
    it 'prefers prices in title' do
      finder = PriceFinder.new('Cuadro Epic. Antes 550, ahora 500', 'Precio 600e', nil, true)
      expect(finder.find_price).to eq 500
    end

    it 'prefers regular price in title over priority regex in descriptions' do
      finder = PriceFinder.new('Froggy 721 1600e', 'Rebajada a 1800')
      expect(finder.find_price).to eq 1600
    end

    #it 'prefers the lowest price'
    it 'prefers the last price to appear' do
      finder = PriceFinder.new('Froggy 721', 'Precio 1100e...1000e')
      expect(finder.find_price).to eq 1000
    end

    it 'prefers prices in the typical range' do
      finder = PriceFinder.new('Froggy 721', 'Esta por 1100e. Tambien horquilla suelta por 200e.')
      expect(finder.find_price).to eq 1100
    end

    it 'applies typical range filter before last price filter'
  end

  describe 'priority regexes' do
    # TODO ineffective tests: prefers last number anyway
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

end
