class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  before_action :authenticate_user!

  #skip_before_action :verify_authenticity_token
  #  rescue_from ActionController::InvalidAuthenticityToken do |exception|
  #    current_user.forget_me!   # Example method that will destroy the user cookies
  #  end

   # Resque form for invalid authentificitytoken
  # rescue_from ActionController::InvalidAuthenticityToken, :with => :bad_token
  # def bad_token
  #   flash[:warning] = "Session expired"
  #   redirect_to root_path
  # end

  # API POST REGUEST ALLOW CROSS DOMAIN
  # before_filter :cor
  # def cor
  #   headers["Access-Control-Allow-Origin"]  = "*"
  #   headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
  #   headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")
  #   head(:ok) if request.request_method == "OPTIONS"
  # end



  #add_flash_types :info, :error, :warning

  #to render
#   <% flash.each do |type, msg| %>
#   <div>
#     <%= msg %>
#   </div>
# <% end %>

#redirect_to, then render a flash message, 
# or

#if you want to set a flash message for the current action?
#flash.now  with render 
#Here’s an example:

# def index
#   @books = Book.all
#   flash.now[:notice] = "We have exactly #{@books.size} books available."
# end

end
