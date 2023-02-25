class HomeController < ApplicationController
  def landing_page
    if user_signed_in?
      render :logged_in
    else
      render :landing_page
    end
  end

end