ActiveAdmin.register ActionKind do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :abbreviation
  #
  # or
  #
  # permit_params do
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
