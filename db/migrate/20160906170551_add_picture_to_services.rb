class AddPictureToServices < ActiveRecord::Migration
  def change
    add_column :services, :picture, :string
  end
end
