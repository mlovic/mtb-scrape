require 'active_record'

class AddUsernameAndVisitsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :username, :string
    add_column :posts, :visits, :integer
  end
end
