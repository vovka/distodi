class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :items, :services, :companies]
  before_action :authenticate_user!

  def show
    @last_services = Service.user_services(@user.id).last(3)
    @last_companies = Company.user_companies(@user.id).last(3)
    @unconfirmed_count = @user.items.unconfirmed_services.count
  end

  def edit
  end

  def items
  end

  def services
    @all_services = Service.user_services(@user.id)
  end

  def companies
    @all_companies = Company.user_companies(@user.id)
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :country, :city, :street, :postal_code, :notice, :picture)
  end
end
