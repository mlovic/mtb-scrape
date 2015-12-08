require 'active_record'

class AddPostIdToBikes < ActiveRecord::Migration
  def change
    add_column :bikes, :post_id, :integer
  end
end
