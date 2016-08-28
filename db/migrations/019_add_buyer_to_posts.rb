require 'active_record'

class AddBuyerToPosts < ActiveRecord::Migration

  def change
    add_column :posts, :buyer, :boolean, default: false
  end

end
