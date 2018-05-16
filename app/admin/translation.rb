ActiveAdmin.register Translation do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :locale, :key, :value, :interpolations_raw, :is_proc
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  filter :locale, as: :select, collection: ->{ Translation.pluck(:locale).uniq }
  filter :key
  filter :value
  filter :interpolations
  filter :is_proc
end
