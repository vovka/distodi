class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.belongs_to :category, index:true

      t.timestamps null: false
    end
  end
end
