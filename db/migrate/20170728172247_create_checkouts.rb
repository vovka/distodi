class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.integer :charge_amount
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
