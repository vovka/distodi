Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, "consumer_key", "consumer_secret", :scope => 'r_fullprofile r_emailaddress r_network', :fields => ["email-address", "first-name", "last-name", "picture-url"]
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {verify_iss: false}
  provider :facebook, ENV['f7cdc012608b48c51247ffedec9de602'], ENV['d4795be7e88382b8f7c2e577e7ba4dc4']
end
