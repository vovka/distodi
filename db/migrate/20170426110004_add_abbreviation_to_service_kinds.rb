class AddAbbreviationToServiceKinds < ActiveRecord::Migration
  def change
    add_column :action_kinds, :abbreviation, :string
  end
end
