class AddCommentToItem < ActiveRecord::Migration
  def change
    add_column :items, :comment, :string, limit: 2000
  end
end
