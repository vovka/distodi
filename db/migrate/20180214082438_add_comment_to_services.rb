class AddCommentToServices < ActiveRecord::Migration
  def change
    add_column :services, :comment, :string, limit: 2000
  end
end
