class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :phone
      t.string :country
      t.string :city
      t.string :street
      t.string :postal_code

      t.timestamps null: false
    end
  end
end
