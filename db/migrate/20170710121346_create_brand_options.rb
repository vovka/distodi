class CreateBrandOptions < ActiveRecord::Migration
  def change
    create_table :brand_options do |t|
      t.string :name
      t.belongs_to :category

      t.timestamps null: false
    end
  end
end
