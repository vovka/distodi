class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.belongs_to :item
      t.belongs_to :attribute_kind
      t.string :value

      t.timestamps null: false
    end
  end
end
