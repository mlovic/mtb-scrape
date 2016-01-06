require 'active_record'

class Model < ActiveRecord::Base
  enum confirmation_status: [ :unconfirmed, :confirmed ]
  # uniqueness -  model and brand combo
  #
  validates :name, presence: true
  validates :name, uniqueness: {scope: :brand_id,
                                case_sensitive: false}
  validates :travel, numericality: { only_integer: true,
                                     greater_than_or_equal_to: 100,
                                     less_than_or_equal_to: 230 }, allow_nil: true

  belongs_to :brand
  has_many :bikes

end
