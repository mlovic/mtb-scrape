require 'active_record'

class AddSoldToBikes < ActiveRecord::Migration

  def change
    add_column :bikes, :is_sold, :boolean
  end

end
