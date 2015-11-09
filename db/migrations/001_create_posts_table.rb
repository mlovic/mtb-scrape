require 'active_record'

class CreatePostsTable < ActiveRecord::Migration

  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.string :images
      t.string :uri
    end
  end

end
