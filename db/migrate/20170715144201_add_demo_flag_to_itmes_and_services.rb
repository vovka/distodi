class AddDemoFlagToItmesAndServices < ActiveRecord::Migration
  def change
    add_column :items, :demo, :boolean
    add_column :services, :demo, :boolean
    add_column :companies, :demo, :boolean
  end
end
