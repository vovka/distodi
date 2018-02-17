class RecreateImageVersions < ActiveRecord::Migration
  def up
    recreate_user_versions
    recreate_company_versions
    recreate_item_versions
    recreate_service_versions
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end

  private

  def recreate_user_versions
    recreate_versions User, picture: [:icon]
  end

  def recreate_company_versions
    recreate_versions Company, picture: [:icon]
  end

  def recreate_item_versions
    recreate_versions Item,
      picture: [:cover, :mini, :thumb, :additional_photo, :list],
      picture2: [:cover, :mini, :thumb, :additional_photo, :list],
      picture3: [:cover, :mini, :thumb, :additional_photo, :list],
      picture4: [:cover, :mini, :thumb, :additional_photo, :list],
      picture5: [:cover, :mini, :thumb, :additional_photo, :list]
  end

  def recreate_service_versions
    recreate_versions Service,
      picture: [:cover, :mini, :thumb, :additional_photo, :list],
      picture2: [:cover, :mini, :thumb, :additional_photo, :list],
      picture3: [:cover, :mini, :thumb, :additional_photo, :list],
      picture4: [:cover, :mini, :thumb, :additional_photo, :list]
  end

  def recreate_versions(model, columns_with_versions)
    model.find_each do |instance|
      columns_with_versions.each do |column, versions|
        begin
          instance.send(column).cache_stored_file!
          instance.send(column).retrieve_from_cache!(instance.send(column).cache_name)
          instance.send(column).recreate_versions!(*versions)
          instance.save!
        rescue => e
          puts  "ERROR: YourModel: #{instance.id} -> #{e.to_s}"
        end
      end
    end
  end
end
