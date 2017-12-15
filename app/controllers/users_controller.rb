class UsersController < ApplicationController
  layout 'item'
  before_action :set_user, only: [:show, :edit, :update, :destroy, :items, :services, :companies]
  before_action :authenticate_user!

  def show
    redirect_to edit_user_path(@user)
  end

  def edit
    authorize @user
  end

  def services
    @pending_services = current_user.services.pending
    @declined_services = current_user.assigned_services.declined
    @services_for_approval = current_user.assigned_services.pending
  end

  def companies
    @all_companies = Company.user_companies(@user.id).distinct
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to @user, notice: t(".notice")
    else
      render :edit
    end
  end

  def destroy
    authorize @user
    if @user.valid_password?(params[:user][:password])
      sign_out @user
      @user.destroy
      redirect_to root_path, notice: t(".success")
    else
      redirect_to edit_user_url, notice: t(".password_invalid")
    end
  end

  def profile
    redirect_to edit_user_path(current_user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    country = ISO3166::Country.find_country_by_name(params[:user][:country]) ||
              ISO3166::Country.new(params[:user][:country])
    params[:user][:country] = country.name if country.present?
    params.require(:user).permit(:first_name, :last_name, :phone, :country, :city, :address, :postal_code, :notice, :picture)
  end
end
