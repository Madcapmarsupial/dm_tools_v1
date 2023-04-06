module Generatable
  extend ActiveSupport::Concern

  included do
    # any code that you want inside your class
   def create_response(prompt)
    #filters  the output of the Response create to load into a new quest
    response = Response.build_response(prompt, current_user.id)  #$$$ inside Response     
  end

  end

  class_methods do
    # define class methods here
   
  end
end