class AddFleetManagementColumnsToService < ActiveRecord::Migration
  def change
    change_table :services do |t|
      t.float :distance
      t.float :fuel
      t.string :customer
      t.float :start_lat
      t.float :start_lng
      t.float :end_lat
      t.float :end_lng
      t.integer :road_reasons, array: true, default: []
      t.date :performed_at
    end
  end
end
