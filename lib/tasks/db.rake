namespace :db do
  desc "Dumps the database to db/APP_NAME.dump"
  task dump: :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.sql"
    end
    puts cmd
    system cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task restore: :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  namespace :dump do
    desc "Emails DB dump"
    task send: :environment do
      emails = ENV["EMAILS"].split(/[\s;,]/).join(", ")
      m = ActionMailer::Base.mail(to: emails,
                                  from: "noreply@distodi-devops.com",
                                  subject: "DB dump",
                                  content_type: "multipart/mixed",
                                  body: "")
      file_path = with_config do |app, *_|
        "#{Rails.root}/db/#{app}.sql"
      end
      m.attachments["db.dump"] = File.read(file_path)
      m.deliver
    end
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:host],
          ActiveRecord::Base.connection_config[:database],
          ActiveRecord::Base.connection_config[:username]
  end
end
