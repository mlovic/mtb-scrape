require 'active_record'

class AddTimestampsToBikes < ActiveRecord::Migration
  def change
    change_table(:bikes) { |t| t.timestamps }
  end
end
