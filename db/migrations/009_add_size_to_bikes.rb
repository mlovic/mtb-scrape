require 'active_record'

class AddSizeToBikes < ActiveRecord::Migration

  def change
    add_column :bikes, :size, :string
  end

end
