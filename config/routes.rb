OmgCi::Application.routes.draw do
  devise_for :users
  resources :projects, :only => [:index, :new, :create, :destroy] do
    resources :suites, :only => [:new, :create]
  end

  resources :suites, :only => [:edit, :destroy, :update]
  resources :suite_runs, :only => [:show]

  namespace :admin do
    resources :users, :only => [:index, :edit, :update]
  end

  root :to => 'projects#index'
end
