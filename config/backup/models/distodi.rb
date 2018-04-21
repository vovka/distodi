# encoding: utf-8

APP_ENV = ENV["APP_ENV"] || "development"

require "figaro"
path_to_app_file = File.expand_path("../config/application.yml", __FILE__)
Figaro.application = Figaro::Application.new(environment: APP_ENV, path: path_to_app_file)
Figaro.load

##
# Backup Generated: distodi
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t distodi [-c <path_to_configuration_file>]
#
Backup::Model.new(:distodi, 'Backup distodi DB and files') do
  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  # split_into_chunks_of 250
  ##
  # Archive [Archive]
  #
  # Adding a file or directory (including sub-directories):
  #   archive.add "/path/to/a/file.rb"
  # archive.add "public/uploads/"
  #
  # Excluding a file or directory (including sub-directories):
  #   archive.exclude "/path/to/an/excluded_file.rb"
  #   archive.exclude "/path/to/an/excluded_directory
  #
  # By default, relative paths will be relative to the directory
  # where `backup perform` is executed, and they will be expanded
  # to the root of the filesystem when added to the archive.
  #
  # If a `root` path is set, relative paths will be relative to the
  # given `root` path and will not be expanded when added to the archive.
  #
  #   archive.root '/path/to/archive/root'
  #
  # For more details, please see:
  # https://github.com/meskyanichi/backup/wiki/Archives
  #
  archive :"distodi.com" do |archive|
    # Run the `tar` command using `sudo`
    # archive.use_sudo
    archive.add "public/uploads/"
  end

  database PostgreSQL do |db|
    path_to_db_config_file = File.expand_path("../config/database.yml", __FILE__)
    db_config_file = File.read(path_to_db_config_file)
    db_config = YAML.load(ERB.new(db_config_file).result)[APP_ENV]

    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = db_config["database"]
    db.username           = db_config["username"]
    db.password           = db_config["password"]
    db.host               = db_config["host"]
    db.port               = db_config["port"]
    db.socket             = db_config["socket"]
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    # db.skip_tables        = ['skip', 'these', 'tables']
    # db.only_tables        = ['only', 'these' 'tables']
    # db.additional_options = []
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 5
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the Wiki for other delivery options.
  # https://github.com/meskyanichi/backup/wiki/Notifiers
  #
  # notify_by Mail do |mail|
  #   mail.on_success           = true
  #   mail.on_warning           = true
  #   mail.on_failure           = true
  #
  #   mail.address              = "smtp.gmail.com"
  #   mail.port                 = 587
  #   # mail.user_name            = "distodi.maropen@gmail.com"
  #   # mail.password             = "1q2w3e4r5t6y7u8i9o0"
  #   mail.user_name            = ENV["gmail_username"]
  #   mail.password             = ENV["gmail_password"]
  #   mail.authentication       = "plain"
  #   mail.encryption           = :starttls
  #
  #   mail.from                 = "backup@distodi.com"
  #   mail.to                   = "scherbina.v@gmail.com"
  #   mail.domain               = "distodi.com"
  # end
end
