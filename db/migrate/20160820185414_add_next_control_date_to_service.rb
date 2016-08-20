class AddNextControlDateToService < ActiveRecord::Migration
  def change
    add_column :services, :next_control, :date
  end
end
