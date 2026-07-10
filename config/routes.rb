Rails.application.routes.draw do
  root "home#index"
  get "/history", to: "pages#history"
  get "/monuments", to: "pages#monuments"
  get "/monuments/:id", to: "pages#monument"
  get "/accommodation", to: "pages#accommodation"
  get "/events", to: "pages#events"
  get "/sabhyata", to: "pages#sabhyata"
  get "/experiences", to: "pages#experiences"
  get "/experiences/eco-trail", to: "pages#eco_trail"
  get "/experiences/:id", to: "pages#experience_detail"
  get "up" => "rails/health#show", as: :rails_health_check
end
