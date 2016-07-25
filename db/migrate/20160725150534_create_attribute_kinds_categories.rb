class CreateAttributeKindsCategories < ActiveRecord::Migration
  def change
    create_table :attribute_kinds_categories do |t|
      t.references :attribute_kind
      t.references :category
    end
  end
end
