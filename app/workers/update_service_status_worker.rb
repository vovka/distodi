class UpdateServiceStatusWorker
  include Sidekiq::Worker

  def perform(company_id)
    company = Company.where(id: company_id).first
    company.update_status
  end
end
