class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.string :name
      t.integer :chart_type
      t.boolean :active, default: false
      t.string :label_attribute
      t.string :format, array: true, default: []
      t.string :data_attribute
      t.string :select
      t.string :joins
      t.string :group
      t.string :order
      t.boolean :single_serial, default: false
      t.integer :position

      t.timestamps null: false
    end
  end
end
