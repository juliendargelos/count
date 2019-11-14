Rails.application.routes.draw do
  root to: 'home#index'

  get 'login' => 'sessions#new', as: :new_session
  post 'login' => 'sessions#create', as: :sessions
  get 'logout' => 'sessions#destroy', as: :destroy_session

  resource :settings, only: :show
  resources :users, except: :show
  resources :companies, except: :show
  resources :projects, except: :show
  resources :people, except: :show
  resources :pricings, only: [:index, :update, :create, :destroy]
  resources :referentials, only: [:index, :update, :create, :destroy]
  resources :taxes, only: [:index, :update, :create, :destroy]

  resources :missions do
    # get '/(:scope)' => 'missions#index', on: :collection, as: '', constraints: { scope: /(?:in-progress|ended)?/ }
    # get '/' => 'missions#show', on: :member
    post 'compute', on: :member
  end

  get(
    'missions/:uuid/:export' => 'missions#show',
    as: :mission_export,
    export: /(?:quotation|invoice)/
  )

  resources :tasks, only: [:create, :update, :destroy] do
    post 'compute', on: :collection
  end

  handles_not_found_status
end
