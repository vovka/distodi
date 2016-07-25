class CreateAttributeKinds < ActiveRecord::Migration
  def change
    create_table :attribute_kinds do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
