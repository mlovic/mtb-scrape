require 'active_record'

class Model < ActiveRecord::Base
  enum confirmation_status: [ :unconfirmed, :confirmed ]
  # uniqueness -  model and brand combo
  #
  validates :name, presence: true
  validates :name, uniqueness: {scope: :brand_id,
                                case_sensitive: false}
  belongs_to :brand
  has_many :bikes

end
