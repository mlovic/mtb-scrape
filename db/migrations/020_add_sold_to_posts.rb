require 'active_record'

class AddSoldToPosts < ActiveRecord::Migration

  def change
    add_column :posts, :sold, :boolean
    add_index  :posts, :sold
  end

end
