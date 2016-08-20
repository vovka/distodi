class CreateServiceFields < ActiveRecord::Migration
  def change
    create_table :service_fields do |t|
      t.references :service, index: true, foreign_key: true
      t.references :service_kind, index: true, foreign_key: true
      t.string :text
      t.timestamps null: false
    end
  end
end
