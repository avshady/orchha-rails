Rails.application.routes.draw do
  resource :session

  namespace :admin do
    root "dashboard#index"
    resources :content_blocks, param: :key, only: [ :edit, :update ]
    resources :uploads, only: [ :create ]
    get "export", to: "exports#show", defaults: { format: :json }

    get    "collections/:key",                    to: "collections#show",  as: :collection
    get    "collections/:key/records/new",        to: "records#new",       as: :new_collection_record
    post   "collections/:key/records",            to: "records#create",    as: :collection_records
    get    "collections/:key/records/:index/edit", to: "records#edit",     as: :edit_collection_record
    patch  "collections/:key/records/:index",     to: "records#update",    as: :collection_record
    delete "collections/:key/records/:index",     to: "records#destroy"
    patch  "collections/:key/records/:index/move", to: "records#move",     as: :move_collection_record
  end

  root "home#index"
  get "/history", to: "pages#history"
  get "/monuments", to: "pages#monuments"
  get "/monuments/:id", to: "pages#monument"
  get "/accommodation", to: "pages#accommodation"
  get "/events", to: "pages#events"
  get "/sabhyata", to: "pages#sabhyata"
  get "/experiences", to: "pages#experiences"
  get "/experiences/eco-trail", to: "pages#eco_trail"
  get "/experiences/river-kayaking", to: "pages#river_kayaking"
  get "/experiences/:id", to: "pages#experience_detail"
  get "up" => "rails/health#show", as: :rails_health_check
end
