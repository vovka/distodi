class CreateActionKinds < ActiveRecord::Migration
  def change
    create_table :action_kinds do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
