class CreateDemoDataWorker
  include Sidekiq::Worker

  def perform(resource_class, resource_id)
    resource = resource_class.constantize.find(resource_id)
    DemoDataService.new(resource).perform
  end
end
