ActiveAdmin.register ActionKind do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :abbreviation, category_ids: []
  #
  # or
  #
  # permit_params do
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    id_column
    resource_class.content_columns.each { |col| column col.name.to_sym }
    column :categories do |action_kind|
      action_kind.categories.map { |c| c.name }.join(", ")
    end
    actions
  end

  show do
    attributes_table do
      resource_class.content_columns.each { |col| row col.name.to_sym }
      row :categories do |action_kind|
        action_kind.categories.map { |c| c.name }.join(", ")
      end
    end
    active_admin_comments
  end

  form title: "Action Kinds" do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute
    f.inputs do
      f.input :categories
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
