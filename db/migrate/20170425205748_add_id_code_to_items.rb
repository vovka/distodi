class AddIdCodeToItems < ActiveRecord::Migration
  def change
    add_column :items, :id_code, :string, index: true
  end
end
