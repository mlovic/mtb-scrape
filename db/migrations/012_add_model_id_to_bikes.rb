require 'active_record'

class AddModelIdToBikes < ActiveRecord::Migration
  def change
    add_column :bikes, :model_id, :integer
    add_index :bikes, :model_id
  end
end
