require 'active_record'

class Brand < ActiveRecord::Base
  enum confirmation_status: [ :unconfirmed, :confirmed ]

  validates :name, presence: true, uniqueness: true
  has_many :models
  #def destroy
    #raise ActiveRecord::ReadOnlyRecord
  #end
end
