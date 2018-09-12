class CreateBlockchainTransactionData < ActiveRecord::Migration
  def change
    create_table :blockchain_transaction_data do |t|
      t.string :action
      t.string :blockchain_hash
      t.references :from, polymorphic: true, index: true
      t.references :item, index: true, foreign_key: true
      t.references :service, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
