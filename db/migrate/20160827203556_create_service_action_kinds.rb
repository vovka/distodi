class CreateServiceActionKinds < ActiveRecord::Migration
  def change
    create_table :service_action_kinds do |t|
      t.references :service, index: true, foreign_key: true
      t.references :action_kind, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
