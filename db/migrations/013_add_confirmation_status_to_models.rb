require 'active_record'

class AddConfirmationStatusToModels < ActiveRecord::Migration

  def change
    add_column :models, :confirmation_status, :integer, default: 0
    add_index  :models, :confirmation_status
  end

end
