class AddApproverTypeToServices < ActiveRecord::Migration
  def change
    add_column :services, :approver_type, :string
  end
end
