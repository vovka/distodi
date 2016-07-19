class AddAdditionalFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :website, :string
    add_column :companies, :notice, :string
    add_column :companies, :first_name, :string
    add_column :companies, :last_name, :string
  end
end
