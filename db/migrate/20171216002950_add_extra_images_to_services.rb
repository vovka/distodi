class AddExtraImagesToServices < ActiveRecord::Migration
  def change
    add_column :services, :picture2, :string
  end
end
