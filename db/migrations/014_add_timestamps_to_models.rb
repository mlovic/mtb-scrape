require 'active_record'

class AddTimestampsToModels < ActiveRecord::Migration
  def change
    change_table(:models) { |t| t.timestamps }
  end
end
