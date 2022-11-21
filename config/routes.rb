Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   #root "quests#index"

   #get '/quests', to: 'quests#index'


   #get '/quests', to: 'quests#show'


   root "quests#index"

   get "/quests/reroll(.:format)", to: "quests#reroll"

   resources :quests 
  #  do 
  #  member do 
  #   patch :reroll
  #   put :reroll
  #  end
  #end
   
end



# Rails.application.routes.draw do
#   resources :brands, only: [:index, :show] do
#     resources :products, only: [:index, :show]
#   end

#   resource :basket, only: [:show, :update, :destroy]

#   resolve("Basket") { route_for(:basket) }
# end
