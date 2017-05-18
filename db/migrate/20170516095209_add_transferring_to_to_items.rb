class AddTransferringToToItems < ActiveRecord::Migration
  def change
    add_reference :items, :transferring_to, references: :users
  end
end
