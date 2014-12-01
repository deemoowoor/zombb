Zombb::Application.routes.draw do

  #match '*path', :via => [:options], :controller => 'application', :action => 'cors_preflight_check'

  root 'posts#index'

  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users

  resources :posts do
      resources :post_comments
  end

end
