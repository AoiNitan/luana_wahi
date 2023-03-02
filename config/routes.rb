Rails.application.routes.draw do

  root to: "public/homes#top"


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
  devise_for :user, controllers: {
  registrations: "pubic/registrations",
  sessions: "pubic/sessions"
  }

  scope module: :public do
    resources :post_images, only: [:new, :create, :index, :show, :destroy]

  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
