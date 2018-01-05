require 'devise'

module DefaultParams
  extend ActiveSupport::Concern

  def process_with_default_params(action, method, *args)
    args[0] ||= {}
    args[0].merge!({locale: I18n.locale})
    process_without_default_params(action, method, *args)
  end

  included do
    include Devise::Test::ControllerHelpers
    let(:default_params) { {locale: I18n.locale} }
    alias_method_chain :process, :default_params
  end
end

RSpec.configure do |config|
  config.include DefaultParams, type: :controller
  config.include DefaultParams, type: :view
end
