class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.boolean :read, default: false
      t.belongs_to :user
      t.index :user_id
    end
  end
end
