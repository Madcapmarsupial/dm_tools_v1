class ApplicationController < ActionController::Base
  #skip_before_action :verify_authenticity_token
   rescue_from ActionController::InvalidAuthenticityToken do |exception|
     current_user.forget_me!   # Example method that will destroy the user cookies
   end

end
