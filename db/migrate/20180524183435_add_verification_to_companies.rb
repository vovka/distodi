class AddVerificationToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :verified, :boolean, default: false
  end
end
