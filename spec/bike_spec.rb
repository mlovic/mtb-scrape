require_relative 'spec_helper'

RSpec.describe Bike do
  let(:post) { Post.create(fixture('post.yml')) }
  let(:bike) { Bike.new(fixture('bike.yml')) }

  it 'delegates post methods to post' do
    bike.post = post
    expect(bike.title).to eq "USADO (REBAJADO)CUADRO MONDRAKER FOXY RR+TALAS 36 RC2"
  end

end
