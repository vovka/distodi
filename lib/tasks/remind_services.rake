namespace :not_approved do
  task reminder: :environment do
    ServicesReminder.new.call
  end
end
