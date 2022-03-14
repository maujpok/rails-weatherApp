Rails.application.routes.draw do
  root to: "cities#index"
  
  get     "/about",         to:"pages#about"
  get     "cities/:id",     to:"cities#forecast",     as:"city"
  post    "cities",         to:"cities#create"
  get "*path",              to:"pages#not_found"
  
  resources :cities,        only: [:create, :destroy]
end