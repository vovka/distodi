class AddItemIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :item_id, :integer
  end
end
