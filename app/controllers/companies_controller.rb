class CompaniesController < ApplicationController
  layout 'item'
  before_action :set_company, only: [:show, :edit, :update, :destroy, :items, :services]
  before_action :authenticate_company!

  def show
    redirect_to edit_company_path(@company)
  end

  def items
    @items = @company.services.map(&:item).uniq
  end

  def services
    @pending_services = @company.assigned_services.pending
    @approved_services = @company.assigned_services.approved
    @declined_services = @company.assigned_services.declined
  end

  def edit
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: t(".notice")
    else
      render :edit
    end
  end

  def destroy
    if @company.valid_password?(params[:company][:password])
      sign_out @company
      @company.destroy
      redirect_to root_path, notice: t(".success")
    else
      redirect_to edit_company_url, notice: t(".password_invalid")
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :phone, :country, :city, :address, :postal_code, :picture)
  end
end
