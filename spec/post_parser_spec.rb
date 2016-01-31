require_relative 'spec_helper'

RSpec.describe PostParser do

  describe 'price' do
    it 'finds price' do
      post = build(:post)
      expect(PostParser.parse(post)[:price]).to eq 1250

    end
  end

  let(:post) { build(:post) }
  describe '.parse' do
    # think works? left half done
    it 'finds frame_only' do
      expect(PostParser.parse(post)[:frame_only]).to be true
      post.title = 'Santa Cruz v10'
      expect(PostParser.parse(post)[:frame_only]).not_to be true
    end

    it 'finds size' do
      expect(PostParser.parse(post)[:size]).to eq 'L'
      post.description = 'Santa Cruz v10 talla xs'
      expect(PostParser.parse(post)[:size]).to eq 'XS'
    end

    it 'finds buyer' do
      pending 'changed to accomodate Dynatable'
      # figure this out
      #expect(PostParser.parse(post)[:seller]).to be false
      post.title = 'Busco Santa Cruz v10'
      expect(PostParser.parse(post)[:seller]).to be false
      post.title = 'compro Santa Cruz v10 '
      expect(PostParser.parse(post)[:seller]).to be false
    end

    it 'adds attributes to post' do
      # don't think it does, DEL
    end

    it 'returns only attributes needed for bike' do
      expect(PostParser.parse(post).keys).to match_array [:price, :brand_id, :model_id, :size, :frame_only]
      # TODO add sold
    end

    it 'saves bike in db' do
      pending
      expect(Bike.all.size).to eq 0
      Brand.create name: 'Mondraker', confirmation_status: 'confirmed' 
      PostParser.parse(post)
      expect(Bike.all.size).to eq 1
      bike = Bike.take
      expect(bike.price).to eq 1250
      expect(bike.size).to eq 'L'
      expect(bike.frame_only).to be true
      expect(bike.brand_name).to eq 'Mondraker'
    end

    it 'searches confirmed first' do
      post.title = 'Marzzochi Mondraker Plunder con ruedas Mavic crossmax'
      mondraker = Brand.create name: 'Mondraker', confirmation_status: 'confirmed' 
      mavic     = Brand.create name: 'Mavic'    , confirmation_status: 'unconfirmed'
      attrs = PostParser.parse post

      expect(attrs[:brand_id]).to eq Brand.find_by(name: 'Mondraker').id

      mondraker.unconfirmed!
      mavic.confirmed!
      attrs = PostParser.parse post

      expect(attrs[:brand_id]).to eq Brand.find_by(name: 'Mavic').id
    end

  end

end
