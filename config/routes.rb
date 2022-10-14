Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   #root "quests#index"

   #get '/quests', to: 'quests#index'

   get '/quests', to: 'quests#show'

   
end
