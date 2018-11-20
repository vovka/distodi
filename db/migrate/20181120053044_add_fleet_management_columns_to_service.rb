class AddFleetManagementColumnsToService < ActiveRecord::Migration
  def change
    change_table :services do |t|
      t.float :distance
      t.float :fuel
      t.string :customer
    end
  end
end
