require 'active_record'

class Model < ActiveRecord::Base

  # uniqueness -  model and brand combo
  #
  validates :name, presence: true
  belongs_to :brand

end
