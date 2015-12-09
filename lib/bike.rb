require 'active_record'

class Bike < ActiveRecord::Base
  belongs_to :post
  belongs_to :brand
  #delegate post methods to post
  delegate :title, to: :post
  delegate :name, to: :brand, prefix: true

  #validates :name, presence: true
end
