class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :items, :services]
  before_action :authenticate_company!

  def show
    @last_items = @company.services.map(&:item).uniq.last(3)
    @last_services = @company.services.last(3)

  end

  def items
    @items = @company.services.map(&:item).uniq
    
  end

  def services
    @all_services = @company.services
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
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Company was successfully destroyed.'
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :phone, :country, :city, :street, :postal_code, :picture)
  end
end
