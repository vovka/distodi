namespace :remind do
  task not_approved_services: :environment do
    ServicesReminder.new.call
  end
end
