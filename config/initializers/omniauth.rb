Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :linkedin, "consumer_key", "consumer_secret", :scope => 'r_fullprofile r_emailaddress r_network', :fields => ["email-address", "first-name", "last-name", "picture-url"]
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], verify_iss: false
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  on_failure { |env| AuthenticationsController.action(:failure).call(env) }
end
