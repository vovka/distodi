class CreateDemoDataWorker
  include Sidekiq::Worker

  def perform(resource_class, resource_id)
    resource_class = resource_class.constantize
    resource = resource_class.find(resource_id)
    DemoDataService.new(resource).perform
  end
end
