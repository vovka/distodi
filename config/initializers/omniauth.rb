Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], verify_iss: false, name: "google"
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :twitter, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"]
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']

  on_failure { |env| Devise::OmniauthCallbacksController.action(:failure).call(env) }
end
