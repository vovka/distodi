require 'i18n/backend/active_record'

Translation = I18n::Backend::ActiveRecord::Translation

cache_helper = Class.new do
  include I18n::Backend::Cache
  public :cache_key
end.new

Translation.class_eval do
  # When translation is created or updated
  after_commit do |translation|
    key = cache_helper.cache_key(translation.locale, translation.key, "")
    # Delete particular cache key
    Rails.cache.delete(key)
  end
end

module InterpolationsFriendlyCacheBackend
  # When it is included into a I18n backend
  def self.included(base)
    # Copy current implementation of `translate' method
    base.send :alias_method, :original_translate, :translate

    base.instance_eval do
      # Include standard cache backend as well
      include I18n::Backend::Cache
    end

    # Rewrite `translate' implementation from standard cache backend with previous one (which is without caching)
    base.send :define_method, :translate do |*args|
      original_translate(*args)
    end
  end

  # Now cache translation keys, not translated values. It allows to deal with interpolated values caching and
  def lookup(locale, key, scope = [], options = {})
    # Cache key does not include options which are values to interpolate with so the key is constant. Thus we can easily delete it from cache
    _key = cache_key(locale, key, "")
    I18n.perform_caching? ? fetch(_key) { super } : super
  end
end

if Translation.table_exists?
  # I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)
  # I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Cache)
  I18n::Backend::ActiveRecord.send(:include, InterpolationsFriendlyCacheBackend)
  I18n.cache_store = Rails.cache
  I18n::Backend::ActiveRecord.send(:include, I18n::Backend::ActiveRecord::Missing)
  # I18n.backend = I18n::Backend::ActiveRecord.new

  # I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)
  # I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
  # I18n::Backend::Chain.send(:include, I18n::Backend::ActiveRecord::Missing)
  I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new, I18n::Backend::Simple.new)
end

# I18n::Backend::ActiveRecord.configure do |config|
#   config.cleanup_with_destroy = true # defaults to false
# end
