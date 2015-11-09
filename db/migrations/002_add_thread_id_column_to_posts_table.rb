require 'active_record'

class AddThreadIdColumnToPostsTable < ActiveRecord::Migration

  def change
    add_column :posts, :thread_id, :integer
    add_index  :posts, :thread_id
  end

end
