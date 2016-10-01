class AddConfirmedToServices < ActiveRecord::Migration
  def change
    add_column :services, :confirmed, :boolean
  end
end
