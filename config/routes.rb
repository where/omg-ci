OmgCi::Application.routes.draw do
  devise_for :users
  resources :projects, :only => [:index, :new, :create, :destroy]

  namespace :admin do
    resources :users, :only => [:index, :edit, :update]
  end

  root :to => 'projects#index'
end
