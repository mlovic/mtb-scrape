require 'active_record'

class AddClosedToPosts < ActiveRecord::Migration

  def change
    add_column :posts, :closed, :boolean, default: false
    add_index  :posts, :closed
  end

end
