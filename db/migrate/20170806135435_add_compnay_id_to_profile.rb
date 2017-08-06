class AddCompnayIdToProfile < ActiveRecord::Migration
  def change
    add_reference :profiles, :company, index: true, foreign_key: true
  end
end
