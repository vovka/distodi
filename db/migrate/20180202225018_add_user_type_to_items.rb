class AddUserTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :user_type, :string
  end
end
