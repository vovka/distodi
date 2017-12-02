class AddExtraPicturesToItem < ActiveRecord::Migration
  def change
    add_column :items, :picture2, :string
    add_column :items, :picture3, :string
    add_column :items, :picture4, :string
    add_column :items, :picture5, :string
  end
end
