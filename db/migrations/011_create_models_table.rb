require 'active_record'

class CreateModelsTable < ActiveRecord::Migration

  def change
    create_table :models do |t|
      t.string :name
      t.string :submodel
      t.integer :brand_id, index: true
      t.integer :year
      t.integer :travel
    end

  end
end

