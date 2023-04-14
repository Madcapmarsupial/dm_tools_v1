Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users
  #This is a useful method that defines all the required routes
  #related to user authentication like /users/sign_in, /users/sign_out, and /users/password/new
  
  #stand alone  --> probly need an :edit
 resources :components, only: [:show, :create, :destroy]
  
# you can use a hidden field to upload the magazine_id via the HTTP POST body. 
#While you might prefer to encode the magazine_id in the URL rather than a hidden field,
# having non-nested create routes will make it simpler to define our React components later on. 
#


  root to: "home#landing_page"
  #what is accessed through a user
  resources :users, only: [] 

  #what is accesed through a quest
  resources :quests, only: [:create, :show, :new, :index, :update] do 
    member do
      patch 'update_scene_list'
      patch 'generate'

    end
    #resources :scenes, only: [:new, :index]
    resources :fields, only: [:new, :index]
  end

  resources :fields, only: [:show, :destroy, :create, :update, :edit] do 
    resources :components, only: [:new, :index]
    resources :frames, only: [:new, :index]
    member do 
      patch 'generate'
    end
  end

  resources :scenes, only: [:show, :destroy, :create, :update] do 
    resources :components, only: [:new, :index]
  end

  resources :frames, only: [:show, :destroy, :create, :update, :edit]

  

end #class

  # resources :fields, only: [:show, :create, :update, :destroy] do
  #   resources :traits, only: [ :new, :index]
  #   member do 
  #     patch 'set_place'
  #     patch 'edit'
  #   end
  # end

  #resources :traits, only: [:show, :edit, :update, :create, :destory]

# 
#   resources :brands, only: [:index, :show] do
#     resources :products, only: [:index, :show]
#   end

#   resource :basket, only: [:show, :update, :destroy]

#   resolve("Basket") { route_for(:basket) }
# end