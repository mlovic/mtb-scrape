require 'active_record'

class CreateBikesTable < ActiveRecord::Migration

  def change
    create_table :bikes do |t|
      t.string  :name
      t.integer :brand_id
      t.index   :brand_id
      t.integer :price
      t.boolean :frame_only
    end
  end

end
