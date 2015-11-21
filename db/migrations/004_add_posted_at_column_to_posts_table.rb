require 'active_record'

class AddPostedAtColumnToPostsTable < ActiveRecord::Migration

  def change
    add_column :posts, :posted_at, :datetime
    add_index  :posts, :posted_at
  end

end
