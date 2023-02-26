require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
if ['development', 'test'].include? ENV['RAILS_ENV']
Dotenv::Railtie.load
end

module DMtools
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    


    # this just for development  should not be needed once we get views going  -> i put this in
    config.action_controller.default_protect_from_forgery = false

    #dont have environments set up yet
   config.active_record.encryption.key_derivation_salt = Rails.application.credentials.key_derivation_salt
   config.active_record.encryption.primary_key = Rails.application.credentials.primary_key
   config.active_record.encryption.deterministic_key = Rails.application.credentials.deterministic_key
  #config.active_record.encryption.algorithm = 'aes-256-gcm'
  #config.active_record.encryption.encode_iv_in_body = true


    
  end
end
