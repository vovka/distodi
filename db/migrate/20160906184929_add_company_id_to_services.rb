class AddCompanyIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :company_id, :integer
  end
end
