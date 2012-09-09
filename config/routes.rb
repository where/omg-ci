OmgCi::Application.routes.draw do
  devise_for :users
  resources :projects, :only => [:index, :new, :create, :destroy] do
    resources :suites, :only => [:new, :create]
  end

  resources :suites, :only => [:edit, :destroy, :update, :show]
  resources :suite_runs, :only => [:show]

  namespace :admin do
    resources :users, :only => [:index, :edit, :update]
  end

  get 'unauthorized', :to => 'static#unauthorized'

  root :to => 'projects#index'
end
