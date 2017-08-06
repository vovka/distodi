class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :facebook_uid
      t.string :google_uid
      t.string :twitter_uid
      t.string :linkedin_uid

      t.timestamps null: false
    end

    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
  end
end
