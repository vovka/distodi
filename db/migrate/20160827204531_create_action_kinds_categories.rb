class CreateActionKindsCategories < ActiveRecord::Migration
  def change
    create_table :action_kinds_categories do |t|
      t.references :action_kind, index: true
      t.references :category, index: true
    end
  end
end
