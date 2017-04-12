class AddReasonToServices < ActiveRecord::Migration
  def change
    add_column :services, :reason, :string, limit: 1023
  end
end
