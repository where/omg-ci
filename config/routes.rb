OmgCi::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users, :only => [:index, :edit]
  end

  root :to => 'projects#index'
end
