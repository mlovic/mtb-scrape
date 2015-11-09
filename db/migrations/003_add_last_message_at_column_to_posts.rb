require 'active_record'

class AddLastMessageAtColumnToPosts < ActiveRecord::Migration

  def change
    add_column :posts, :last_message_at, :datetime
    add_index  :posts, :last_message_at
  end

end
