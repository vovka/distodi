class CompanyPolicy
  attr_reader :company, :current_company
  private :company, :current_company

  def initialize(current_company, company)
    @company = company
    @current_company = current_company
  end

  def show?
    current_company?
  end

  def edit?
    current_company?
  end

  def update?
    current_company?
  end

  def destroy?
    current_company?
  end

  private

  def current_company?
    company == current_company
  end
end
