require_relative 'spec_helper'

RSpec.describe ModelFinder do
  let(:post) { Post.new(fixture('post.yml')) }
  let(:title) { post.title }
  let(:description) { post.description }

  before do
    b = Brand.create name: 'Mondraker', confirmation_status: 'confirmed' 
    m = Model.create name: 'Foxy'
    b.models << m
  end

  let(:finder) { ModelFinder.new(title, description) }

  it 'get_brand' do
    expect(finder.get_brand.name).to eq 'Mondraker'
  end

  # should be able to test on individual strings

  it 'get_model' do
    expect(finder.get_model.name).to eq 'Foxy'
  end

end
