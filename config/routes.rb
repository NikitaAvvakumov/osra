Osra::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"

  get 'admin/sponsorships/:sponsor_id/orphans', to: 'admin/orphans#create_sponsorship', as: :new_sponsorship
  get 'admin/sponsorships/:sponsor_id/new/:orphan_id', to: 'admin/sponsorships#fancy_new', as: :sponsorship_fancy_new
  post 'admin/sponsorships/:sponsor_id/create/:orphan_id', to: 'admin/sponsorships#fancy_create', as: :sponsorship_fancy_create
end
