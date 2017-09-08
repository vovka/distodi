class Companies::PasswordsController < Devise::PasswordsController

  layout 'new'

  prepend_before_action :require_no_authentication, except: :new_pass_success

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

  def after_resetting_password_path_for(_)
    companies_passwords_new_pass_success_path
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(_)
    companies_passwords_reset_success_path
  end
end
