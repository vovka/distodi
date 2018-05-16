class ImportTranslations
  FLATTEN_SEPARATOR = I18n::Backend::Flatten::FLATTEN_SEPARATOR

  include I18n::Backend::Flatten

  attr_reader :model, :simple_backend
  private     :model, :simple_backend

  def initialize(model: Translation, simple_backend: I18n::Backend::Simple.new)
    @model = model
    @simple_backend = simple_backend
  end

  def perform
    # translation_lists = all_translations
    translation_lists = custom_translations
    model.transaction do
      translation_lists.each do |translations|
        translations.each do |attributes|
          begin
            Rails.logger.info model.find_or_create_by!(attributes)
          rescue => ex
            Rails.logger.info "Failed to migrate translation for #{attributes[:locale]}.#{attributes[:key]} due to:"
            Rails.logger.info ex.message
            Rails.logger.info ex.backtrace
          end
        end
      end
    end
  end

  private

    def custom_translations
      translation_hashes = read_files
      translation_hashes.map { |translations| flatten translations }
    end

    def read_files
      Dir.glob("./config/locales/**/*.yml").map do |file|
        YAML.load(File.read(file))
      end
    end

    # def all_translations
    #   simple_backend.load_translations
    #   translations = simple_backend.send(:translations)
    #   flatten translations
    # end

    def flatten(translations)
      flattened_translations = flatten_translations(
        "", translations, FLATTEN_SEPARATOR, false
      )
      flattened_translations = flattened_translations.map do |k, v|
        k.to_s.split(FLATTEN_SEPARATOR, 2) << v
      end
      flattened_translations.map do |locale, key, value|
        {
          locale: locale,
          key: key,
          value: value
        }
      end
    end
end
