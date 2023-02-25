class HomeController < ApplicationController
  def landing_page
    if user_signed_in?
      render :user_home
    else
      render :landing_page
    end
  end


end