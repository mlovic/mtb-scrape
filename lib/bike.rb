require 'active_record'

class Bike < ActiveRecord::Base
  belongs_to :post
  #delegate post methods to post
  delegate :title, to: :post

  #validates :name, presence: true
end
