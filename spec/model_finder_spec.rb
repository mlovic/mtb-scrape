require_relative 'spec_helper'

RSpec.describe ModelFinder do
  let(:post) { Post.new(fixture('post.yml')) }
  let(:title) { post.title }
  let(:description) { post.description }
  let(:finder) { ModelFinder.new(title, description) }

  before do
    Brand.create name: 'Mondraker', confirmation_status: 'confirmed' 
    #scott = create(:brand, name: 'Scott')
    #create(:model, name: 'Gambler', brand: scott)
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
      expect(finder.get_model.name).to eq 'Foxy'
      expect(Model.all.size).to eq 1
    end

    it 'doesnt accept name with slashes' do
    end
  end

end
