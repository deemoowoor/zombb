Zombb::Application.routes.draw do

  root 'posts#index'

  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users

  resources :posts do
      resources :post_comments
  end

  resources :stats

end
