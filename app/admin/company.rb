ActiveAdmin.register Company do
  controller do
    def scoped_collection
      Company.unscoped
    end
  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #

  def self.fields
    [
      :name,
      :phone,
      :country,
      :city,
      :address,
      :postal_code,
      # :created_at,
      # :updated_at,
      :email,
      # :encrypted_password,
      # :reset_password_token,
      # :reset_password_sent_at,
      # :remember_created_at,
      :sign_in_count,
      # :current_sign_in_at,
      # :last_sign_in_at,
      # :current_sign_in_ip,
      # :last_sign_in_ip,
      :website,
      :notice,
      :first_name,
      :last_name,
      :picture,
      :verified
    ]
  end

  permit_params fields
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  this = self
  form do |f|
    f.inputs *(this.fields)
    f.actions
  end
end
