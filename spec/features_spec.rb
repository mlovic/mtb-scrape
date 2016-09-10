require_relative 'spec_helper'

RSpec.describe 'Features', loads_DB: true do
  it 'can parse posts and save to bikes table' do
    post = Post.create(fixture('post.yml')) 
    Brand.create name: 'Mondraker', confirmation_status: 'confirmed' 
    attributes = PostParser.parse(post)
    bike = Bike.new(price: attributes[:price], 
                    frame_only: attributes[:frame_only],
                    size: attributes[:size],
                    brand_id: attributes[:brand_id],
                    model_id: attributes[:model_id],
                    post_id: post.id
                   )
    bike.save!
    p bike
  end
end
