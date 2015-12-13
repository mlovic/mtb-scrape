require 'active_record'

class Model < ActiveRecord::Base

  # uniqueness -  model and brand combo
  #
  validates :name, presence: true
  validates :name, uniqueness: {scope: :brand_id,
                                case_sensitive: false}
  belongs_to :brand

end
