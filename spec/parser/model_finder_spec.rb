require_relative '../spec_helper'
require_relative '../factories'
require 'model'
require 'brand'
require 'parser/model_finder'

RSpec.describe ModelFinder, loads_DB: true do
  let(:post) { Post.new(fixture('post.yml')) }
  let(:title) { post.title }
  let(:description) { post.description }
  let(:finder) { ModelFinder.new(title, description) }

  before do
    Brand.create name: 'Mondraker', confirmation_status: 'confirmed' 
    #scott = create(:brand, name: 'Scott')
    #create(:model, name: 'Gambler', brand: scott)
  end

  # TODO important!
  it 'when only model name is present in title' do
    Model.create name: 'Foxy', brand_id: 1, confirmation_status: 'confirmed' 
    Brand.create name: 'Specialized', confirmation_status: 'confirmed' 
    Model.create name: 'Epic', brand_id: 2, confirmation_status: 'confirmed' 
    finder = ModelFinder.new('EPIC SWORKS 2015 a FULL!!', 'Mondraker Dune')
      expect(finder.get_model.name).to eq 'Epic'
      expect(finder.get_brand.name).to eq 'Specialized'
  end

  it 'does not guess precio or vendida' do
    pending
    Model.create name: 'Foxy', brand_id: 1, confirmation_status: 'confirmed' 
    finder = ModelFinder.new('Mondraker vendida', '')
    #puts finder.scan_for_model('TREK TOP FUEL 8 muy mejorada en Talla 18.5" (10.8Kg)').name
      expect(finder.get_model).to eq nil
  # using priority regex
  end

  it 'does not guess blacklisted model names' do
    Model.create name: 'Foxy', brand_id: 1, confirmation_status: 'confirmed' 
    finder = ModelFinder.new('Mondraker vendida', '')
    expect(finder.get_model).to eq nil
    finder = ModelFinder.new('Mondraker talla m', '')
    expect(finder.get_model).to eq nil
    finder = ModelFinder.new('Mondraker precio 2000', '')
    expect(finder.get_model).to eq nil
    finder = ModelFinder.new('Cuadro Mondraker con horquilla', '')
    expect(finder.get_model).to eq nil
  end

  it 'when model name contains space' do
    Model.create name: 'Foxy', brand_id: 1, confirmation_status: 'confirmed' 
    Brand.create name: 'Trek', confirmation_status: 'confirmed' 
    Model.create name: 'Top Fuel', brand_id: 2, confirmation_status: 'confirmed' 
    finder = ModelFinder.new('TREK TOP FUEL 8 muy mejorada en Talla 18.5" (10.8Kg)', 'Mondraker Foxy')
    #puts finder.scan_for_model('TREK TOP FUEL 8 muy mejorada en Talla 18.5" (10.8Kg)').name
      expect(finder.get_model.name).to eq 'Top Fuel'
      expect(finder.get_brand.name).to eq 'Trek'
  end

  it 'searches title before description' do
  end

  it 'get_brand' do
    expect(finder.get_brand.name).to eq 'Mondraker'
  end

  # should be able to test on individual strings

  #it 'guess model' do
    #p finder.guess_model(" Foxy is the bike")
  #end

  describe '#get_model' do
    
    it 'works when model exists' do
      Model.create name: 'Foxy', brand_id: 1
      expect(finder.get_model.name).to eq 'Foxy'
    end

    it 'creates model when model does not exist' do
      pending 'Not using this feature'
      expect(finder.get_model.name).to eq 'Foxy'
      expect(Model.all.size).to eq 1
    end

    it 'doesnt accept name with slashes' do
    end
  end

end
