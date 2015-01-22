Osra::Application.routes.draw do

  namespace :hq do
    resources :partners, except: [:destroy] do
      resources :orphan_lists, only: [:index]
      resources :pending_orphan_lists do
        delete 'destroy', on: :member
        get 'upload', on: :collection
        post 'validate', on: :collection
        post 'import', on: :collection
      end
    end
    resources :users, except: [:destroy]
    resources :sponsors, except: [:destroy]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"

  #build a new sponsorship on the Orphan class instead of the Sponsorship class
  # - replace ", to:" with shorthand "=>"
  # - constrain `:sponsor_id` to a numeric value (ideally should provide second
  # route to handle non-numeric sponsor_id)
  get '/admin/sponsors/:sponsor_id/sponsorships/new' => 'admin/orphans#index',
    as: :new_sponsorship,
    constraints: { :sponsor_id => /\d+/ }

  # cool: allow sponsorships only to sponsors with id < 50
  # get '/admin/sponsors/:sponsor_id/sponsorships/new' => 'admin/orphans#index',
  #   as: :new_sponsorship,
  #   constraints: proc { |req| req.params[:sponsor_id].to_i < 50 }

  # just for fun - the value of `to:` is a Rack endpoint
  # meaning that it can easily map to a Rack app - e.g. one built in Sinatra
  get '/hello', to: proc { |env| [200, {}, ['Hello world!']] }

end
