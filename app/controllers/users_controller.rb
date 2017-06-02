class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :items, :services, :companies]
  before_action :authenticate_user!

  def show
    @last_items = @user.items.last(3)
    @last_services = Service.user_services(@user.id).last(3)
    @last_companies = Company.user_companies(@user.id).distinct.last(3)
    @unconfirmed_count = @user.items.unconfirmed_services.count
  end

  def edit
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
    if @user.update(user_params)
      redirect_to @user, notice: t(".notice")
    else
      render :edit
    end
  end

  def destroy
    sign_out @user
    @user.destroy
    redirect_to root_path, notice: t(".notice")
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    country = ISO3166::Country.find_country_by_name(params[:user][:country]) ||
              ISO3166::Country.new(params[:user][:country])
    params[:user][:country] = country.name if country.present?
    params.require(:user).permit(:first_name, :last_name, :phone, :country, :city, :street, :postal_code, :notice, :picture)
  end
end
