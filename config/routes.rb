Rails.application.routes.draw do

  root 'users/homes#top'
  devise_for :admins, only: :session

  scope module: :users do
  	devise_for :users, only: [:session, :registration]
    delete "notifications" => "notifications#destroy_all"
    resources :notifications, only: [:index, :destroy]
    get 'homes/about'
    resources :users, only: [:show, :edit, :update, :destroy] do
      post 'follow/:id' => 'relationships#follow', as: 'follow'
      post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
      member do
        get :retire, :follow, :follower
      end
    end
    resources :photos, only: [:index, :new, :create, :show, :destroy, :update] do
      member do
        get :likes, :comments
      end
      resources :comments, only: [:create, :destroy, :update]
      resource :likes, only: [:create, :destroy]
    end
    resource :contacts, only: [:new, :create]
    get 'contacts/done' => "contacts#done"
  end


  namespace :admins do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }
    get 'home/top'
    resources :users, only: [:index, :show, :destroy]
    resources :photos, only: [:index, :show, :destroy]
    delete "contacts" => "contacts#destroy_all"
    resources :contacts, only: [:index, :destroy, :show, :update]
  end

  #get '*path', controller: 'application', action: 'render_404'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end