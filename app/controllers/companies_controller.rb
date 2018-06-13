class CompaniesController < ApplicationController
  layout 'item'
  before_action :set_company, only: [:show, :edit, :update, :destroy, :items, :services]
  before_action :authenticate_company!

  def show
    authorize @company
    redirect_to edit_company_path(@company)
  end

  def items
    authorize @company
    @items = @company.services.map(&:item).uniq
  end

  def services
    @pending_services = @company.assigned_services.pending
    @approved_services = @company.assigned_services.approved
    @declined_services = @company.assigned_services.declined
  end

  def edit
    authorize @company
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
    authorize @company
    if @company.update(company_params)
      redirect_to root_path, notice: t(".notice")
    else
      render :edit
    end
  end

  def destroy
    authorize @company
    if @company.valid_password?(params[:company][:password])
      sign_out @company
      @company.destroy
      redirect_to root_path, notice: t(".success")
    else
      redirect_to edit_company_url, notice: t(".password_invalid")
    end
  end

  def profile
    redirect_to edit_company_path(current_company)
  end

  private

  def set_company
    @company = Company.find(params[:id])
    @company = @company.present? ? @company.decorate : @company
  end

  def company_params
    country = ISO3166::Country.find_country_by_name(params[:company][:country]) ||
              ISO3166::Country.new(params[:company][:country])
    params[:company][:country] = country.name if country.present?
    params.require(:company).permit(:name, :phone, :country, :city, :address, :website, :postal_code, :picture, :email, :notice)
  end
end
