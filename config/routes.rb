Rails.application.routes.draw do

  namespace :public do
    get 'relationships/followings'
    get 'relationships/followers'
  end
  namespace :admin do
    get 'homes/top'
  end
  root to: "public/homes#top"

  get "search" => "public/searches#search"


  #管理者
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
  }

  get 'admin' => 'admin/homes#top'

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]

    resources :post_images, only: [:index, :show, :update]

    resources :post_blogs, only: [:index, :show, :update]
  end



  #ユーザー
  devise_for :users, controllers: {
  registrations: "public/registrations",
  sessions: "public/sessions"
  }


  #ゲストログイン
  devise_scope :user do
    post 'guest_sign_in', to: 'public/sessions#new_guest'
  end


  scope module: :public do
    resources :post_images, only: [:new, :create, :index, :show, :destroy] do
      resource :post_images_favorites, only: [:create, :destroy]
      resources :post_images_comments, only: [:create, :destroy]
    end

    resources :post_blogs, only: [:new, :create, :index, :show, :destroy] do
      resource :post_blogs_favorites, only: [:create, :destroy]
      resources :post_blogs_comments, only: [:create, :destroy]
    end

    resources :users do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end



    resources :notifications, only: :index

    get 'users/my_page' => "users#show"
    get 'users/information/edit' => "users#edit"
    patch 'users/information' => "users#update"
    get 'users/unsubscribe' => "users#unsubscribe"
    patch 'users/withdraw' => "users#withdraw"
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
