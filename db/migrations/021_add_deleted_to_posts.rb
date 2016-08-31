require 'active_record'

class AddDeletedToPosts < ActiveRecord::Migration

  def change
    add_column :posts, :deleted, :boolean
  end

end
