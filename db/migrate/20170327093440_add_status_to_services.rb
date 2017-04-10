class AddStatusToServices < ActiveRecord::Migration
  def change
    add_column :services, :status, :string, default: "pending"
    add_column :services, :approver_id, :integer
  end
end
