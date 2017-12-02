class AddPositionToAttributeKind < ActiveRecord::Migration
  def change
    add_column :attribute_kinds, :position, :integer
  end
end
