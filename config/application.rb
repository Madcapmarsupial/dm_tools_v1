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
    


    # set to false for development  should not be needed once we get views going  -> i put this in
    config.action_controller.default_protect_from_forgery = true
    #set to false if you have to test postman routes for testing!

     #config.force_ssl = false #forces https
      # provide a secure connection over SSL.


     #make a new one in the server evironment 
     #bin/rails db:encryption:init
     
#        modified:   config/credentials.yml.enc


    #dont have environments set up yet
   config.active_record.encryption.key_derivation_salt = Rails.application.credentials.key_derivation_salt
   config.active_record.encryption.primary_key = Rails.application.credentials.primary_key
   config.active_record.encryption.deterministic_key = Rails.application.credentials.deterministic_key
  #config.active_record.encryption.algorithm = 'aes-256-gcm'
  #config.active_record.encryption.encode_iv_in_body = true



   


      #In test and development applications get a secret_key_base derived from the app name. 
      #Other environments must use a random key present in config/credentials.yml.enc, 
      #shown here in its decrypted state:


      #A user receives credits, the amount is stored in a session (which is a bad idea anyway, 
      #but we'll do this for demonstration purposes).
      #The user buys something.
      #The new adjusted credit value is stored in the session.
      #The user takes the cookie from the first step (which they previously copied) and replaces the current cookie in the browser.
      #The user has their original credit back.

      #The best solution against it is to not store this kind of data in a session,
      # but in the database. 
      #In this 
        #case store the credit in the database 
        #and the logged_in_user_id in the session.


    #CSRF delete and expire sessions after a set perios
        #class Session < ApplicationRecord
        #  def self.sweep(time = 1.hour)
        #    where("updated_at < ?", time.ago.to_fs(:db)).delete_all
        #    where("updated_at < ? OR created_at < ?", time.ago.to_fs(:db), 2.days.ago.to_fs(:db)).delete_all
        #end
        #end
    
  end
end
