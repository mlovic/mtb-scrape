require_relative 'spec_helper'

RSpec.describe Bike do
  let!(:post) { Post.create(fixture('post.yml')) }
  let!(:bike) { Bike.new(fixture('bike.yml')) }

  it 'delegates post methods to post' do
    bike.post = post
    expect(bike.title).to eq "USADO (REBAJADO)CUADRO MONDRAKER FOXY RR+TALAS 36 RC2"
  end

  it 'orders by last_message time by default' do
    new_post = Post.new(fixture('post.yml'))
    new_post.last_message_at = Time.now
    new_post.save!
    new_bike = Bike.new(fixture('bike.yml')) 
    new_bike.post = new_post
    bike.post = post
    bike.save!
    new_bike.save!
    #p Bike.joins(:post).first.last_message_at
    expect(Bike.all.map(&:id)).to eq [1, 2]
    expect(Bike.ordered_by_last_message.map(&:id)).to eq [2, 1]
  end

end
