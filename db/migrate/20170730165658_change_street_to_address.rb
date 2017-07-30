class ChangeStreetToAddress < ActiveRecord::Migration
  def change
    rename_column :companies, :street, :address
    rename_column :users, :street, :address
  end
end
