require 'active_record'

class Brand < ActiveRecord::Base
  enum confirmation_status: [ :unconfirmed, :confirmed ]
  #def destroy
    #raise ActiveRecord::ReadOnlyRecord
  #end
end
