require 'active_record'

class AddConfirmationStatusColumnToBrands < ActiveRecord::Migration

  def change
    add_column :brands, :confirmation_status, :integer, default: 0
    add_index  :brands, :confirmation_status
  end

end
