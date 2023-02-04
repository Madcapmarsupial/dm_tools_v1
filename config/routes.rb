Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   #root "quests#index"

   resources :quests, only: [:create, :show] do 
      resources :fields, only: [:new, :index]
      member do
        get 'fields/new_setting'
      end
   end

  resources :fields, only: [:show, :create, :update, :destroy] do
    resources :traits, only: [ :new, :index]
    member do 
      
      patch 'set_place'
      #villain
      patch 'edit'
     
    end
  end

  resources :traits, only: [:show, :edit, :update, :create]

end



# Rails.application.routes.draw do
#   resources :brands, only: [:index, :show] do
#     resources :products, only: [:index, :show]
#   end

#   resource :basket, only: [:show, :update, :destroy]

#   resolve("Basket") { route_for(:basket) }
# end
