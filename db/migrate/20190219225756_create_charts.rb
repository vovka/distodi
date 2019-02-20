class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.string :name
      t.integer :chart_type
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
