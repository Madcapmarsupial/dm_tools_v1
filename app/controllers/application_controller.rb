class ApplicationController < ActionController::Base
  #skip_before_action :verify_authenticity_token
   rescue_from ActionController::InvalidAuthenticityToken do |exception|
     current_user.forget_me!   # Example method that will destroy the user cookies
   end

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
