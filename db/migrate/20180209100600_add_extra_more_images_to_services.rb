class AddExtraMoreImagesToServices < ActiveRecord::Migration
  def change
    add_column :services, :picture3, :string
    add_column :services, :picture4, :string
  end
end
