class CreateModelOptions < ActiveRecord::Migration
  def change
    create_table :model_options do |t|
      t.string :name
      t.belongs_to :brand_option

      t.timestamps null: false
    end
  end
end
