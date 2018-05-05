class ImportBrandsAndModels < ActiveRecord::Migration
  def up
    Rake::Task["brands_and_models:import"].invoke
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
