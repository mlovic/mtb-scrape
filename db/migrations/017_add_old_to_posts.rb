require 'active_record'

class AddOldToPosts < ActiveRecord::Migration

  def change
    add_column :posts, :is_old, :boolean, default: false
    add_column :posts, :replaced_at, :datetime
    add_index  :posts, :is_old
  end

end
