Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   #root "quests#index"

   resources :quests, only: [:create, :new, :show] do 
    member do
      patch 'update_encounter_name'
    end

      #resources :fields, only: [:new, :index]
      resources :encounters, only: [:create, :index]
   end

    resources :encounters, only: [:show, :destroy]


  # resources :fields, only: [:show, :create, :update, :destroy] do
  #   resources :traits, only: [ :new, :index]
  #   member do 
  #     patch 'set_place'
  #     patch 'edit'
  #   end
  # end

  #resources :traits, only: [:show, :edit, :update, :create, :destory]


end



# Rails.application.routes.draw do
#   resources :brands, only: [:index, :show] do
#     resources :products, only: [:index, :show]
#   end

#   resource :basket, only: [:show, :update, :destroy]

#   resolve("Basket") { route_for(:basket) }
# end
