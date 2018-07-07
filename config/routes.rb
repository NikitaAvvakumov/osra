Osra::Application.routes.draw do

  root to: "dashboard#index"
  match "/hq/*path", to: redirect("%{path}"), via: :get
  match "/admin/*path", to: redirect("%{path}"), via: :get

  devise_for :admin_users,
    path: '',
    path_names: { sign_in: 'login', sign_out: 'logout' },
    controllers: { :sessions => "devise/sessions" }

  resources :admin_users, except: [:show]

  resources :dashboard, only: [:index]

  resources :organizations, only: [:new, :create]

  resources :orphans, except: [:new, :create, :destroy]

  resources :partners, except: [:destroy] do
    resources :orphan_lists, only: [:index]
    resources :pending_orphan_lists, only: [] do
      delete 'destroy', on: :member
      get 'upload', on: :collection
      post 'validate', on: :collection
      post 'import', on: :collection
    end
  end

  resources :sponsors, except: [:destroy] do

  resources :users, except: [:destroy]
    resources :sponsorships, only: [:create, :destroy] , shallow: true do
      put "inactivate", on: :member
    end
  end

  #build a new sponsorship on the Orphan class instead of the Sponsorship class
  get '/sponsors/:sponsor_id/sponsorships/new', to: 'orphans#index', as: :new_sponsorship

  devise_for :users
end
