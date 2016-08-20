class CreateServiceKinds < ActiveRecord::Migration
  def change
    create_table :service_kinds do |t|
      t.string :title
      t.boolean :with_text

      t.timestamps null: false
    end
  end
end
