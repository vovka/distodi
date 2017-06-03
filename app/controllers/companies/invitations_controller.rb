class Companies::InvitationsController < Devise::InvitationsController
  def accept_resource
    resource = resource_class.accept_invitation(update_resource_params)
    resource.save validate: false
    resource
  end
end
