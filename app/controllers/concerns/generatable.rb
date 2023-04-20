module Generatable
  extend ActiveSupport::Concern
  #this module difenis the methods used for ai compeltion except for model specfific prompts
  #and model specfific key-value filtering -> (not all values that the ai fills can be filled by a user)
    #excluded Class.prompt
    #class.ai_values


  included do
      # any code that you want inside your class
    def create_response(prompt)
      #filters  the output of the Response create to load into a new quest
      response = Response.build_response(prompt, current_user.id)  #$$$ inside Response     
    end

    def get_type
      self.class.to_s.downcase
    end

    def completion_keys
      self.completion == nil ? {} : self.completion.keys
    end

    def user_key_list # completion_lists #completion_desc etc
      self.class.param_list.map(&:to_s) #- self.class.ai_values
    end

    def titleize_key(key)
        #key.gsub("_list", "").pluralize
        new_key = key.gsub("_", " ")
        plural_key = new_key.gsub(" list", "")
        final_key = (plural_key == new_key ? new_key : plural_key.pluralize)
        final_key.titleize
    end

    def create_completion(type, prompt_str)
      #@model = model_class.find_by(id: model_id)
      begin
        if current_user.has_enough_bottlecaps? 
          response = create_response(prompt_str)  #(Quest, @quest.id, prompt_str)
          #validations  built into create_response    
          values = { response_id: response.id, completion: response.text_to_hash, name: response.text_to_hash["#{type}_name"]}
          values
        else
            redirect_to root_path, notice: "insufficient coins"
        end
      rescue StandardError => e
        #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
        redirect_to root_path, alert: e
      end
    end

    def hidden_keys
      []
    end
    
  end

  class_methods do
    # define class methods here
      def blank_completion
        new_completion = Hash.new()

       self.param_list.each { |key| new_completion[key.to_s] = "" }
        new_completion
      end

      def completion_user_list
        self.blank_completion.reject {|k, v| ai_values.include?(k)}
      end

      def completion_hidden_list
        self.blank_completion.filter {|k, v| ai_values.include?(k)}
      end

      def titleize_key(key)
          #key.gsub("_list", "").pluralize
          new_key = key.gsub("_", " ")
          plural_key = new_key.gsub(" list", "")
          final_key = (plural_key == new_key ? new_key : plural_key.pluralize)
          final_key.titleize
      end
  
  end
end