class AddIdCodeToServices < ActiveRecord::Migration
  def change
    add_column :services, :id_code, :string, index: true
  end
end
