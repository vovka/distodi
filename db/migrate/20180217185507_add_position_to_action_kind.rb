class AddPositionToActionKind < ActiveRecord::Migration
  def change
    add_column :action_kinds, :position, :integer
  end
end
