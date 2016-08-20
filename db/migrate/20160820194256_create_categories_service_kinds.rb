class CreateCategoriesServiceKinds < ActiveRecord::Migration
  def change
    create_table :categories_service_kinds do |t|
      t.references :category, index: true, foreign_key: true
      t.references :service_kind, index: true, foreign_key: true
    end
  end
end
