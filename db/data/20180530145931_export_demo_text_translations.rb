class ExportDemoTextTranslations < ActiveRecord::Migration
  def up
    ImportTranslations.new.perform
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
