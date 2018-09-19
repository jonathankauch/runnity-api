Rails.application.routes.draw do
  root 'home#index'
  # external module
  devise_for :users, :controllers => { registrations: 'registrations' }

  # static pages
  get 'advice', to: 'home#advice'
  get 'my_runs', to: 'home#my_runs'

  # parnter
  get 'find_partner', to: 'home#find_partner'
  post 'fetch_partner', to: 'home#fetch_partner'

  #ranking
  get 'ranking', to: 'home#ranking'

  # spot
  get 'spots', to: 'home#spots'
  get 'like_run/:id', to: 'home#like_run', as: 'like_run'
  get 'unlike_run/:id', to: 'home#unlike_run', as: 'unlike_run'
  get 'define_run_as_spot/:id', to: 'home#define_run_as_spot', as: 'define_run_as_spot'
  # root 'home#landing'

  resources :invitations, only: [:create, :update]
  resources :friends

  # profil page
  get 'users/:id', to: 'users#show', as: 'user_show'
  # upload user picture
  post 'users/upload_pics', to: 'users#upload_pics', as: 'user_upload_picture'

  # graph page
  get 'dashboard', to: 'dashboard#index'
  # chat
  get 'messenger', to: 'messenger#index'
  resources :conversations, only: [:create] do
    member do
      post :close
    end
  end

  resources :notifications, only: [:read] do
    post '/read', to: 'notifications#read', as: 'read_notification'
  end

  #friendships
  resources :friendships do
    member do
      post '/accept', to: 'friendships#accept', as: 'accept'
      post '/reject', to: 'friendships#reject', as: 'reject'
    end
  end

  resources :members, only: [:destroy]
  resources :dashboard
  resources :comments

  resources :member_requests do
    member do
      post "accept", to: "member_requests#accept", as: "accept"
      post "reject", to: "member_requests#reject", as: "reject"
    end
  end

  resources :posts do
    member do
      post 'like', to: 'posts#like'
      post 'dislike', to: 'posts#dislike'
      resources :comments
    end
  end
  # delete post rename
  delete 'posts/:id/delete', to: 'posts#destroy', as: 'delete_post'
  delete 'comments/:id/delete', to: 'comments#destroy', as: 'delete_comment'

  resources :events do
    member do
      put "like", to: "events#like"
      put "dislike", to: "events#dislike"
      post "leave", to: "events#leave", as: "leave"
    end
  end

  get "groups_filter", to: "groups#filter", as: "group_filter"
  get "events_filter", to: "events#filter", as: "event_filter"

  resources :groups do
    member do
      put "like", to: "groups#like"
      put "dislike", to: "groups#dislike"
      post "leave", to: "groups#leave", as: "leave"
    end
  end

  resources :configs

  resources :achievements do
    member do
      post 'success' => 'achievements#success'
      post 'failure' => 'achievements#failure'
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # post 'login' => 'sessions#create'
      # devise_for :users, only: [:sessions], path: '',
      #   path_names: {
      #     sign_in: 'login', sign_out: 'logout'
      #   }
      resources :home

      devise_scope :user do
        post 'sign_up' => 'registrations#create', :as => 'sign_up'
        post 'login' => 'sessions#create', :as => 'login'
        delete 'logout' => 'sessions#destroy', :as => 'logout'
      end
      # devise_for :users, only: [:sessions]
      resources :runs do
        member do
          get 'define_as_a_spot' => 'runs#define_as_a_spot', :as => 'define_as_a_spot'
          get 'like' => 'runs#like', :as => 'like'
          get 'unlike' => 'runs#unlike', :as => 'unlike'
        end
      end
      get 'get_spots' => 'runs#get_spots', :as => 'get_spots'

      resources :groups do
        member do
          get 'posts', to: 'groups#posts'
          put "like", to: "groups#like"
          put "dislike", to: "groups#dislike"
          post "leave", to: "groups#leave", as: "leave"
        end
      end

      resources :member_requests, only: [:create, :destroy] do
        member do
          post "accept", to: "member_requests#accept", as: "accept"
          post "reject", to: "member_requests#reject", as: "reject"
        end
      end

      resources :notifications, only: [:index]

      resources :events do
        member do
          get 'posts', to: 'events#posts'
          get 'like', to: 'events#like'
          get 'dislike', to: 'events#dislike'
        end
      end
      #friendships
      get '/friendships/notifications', to: 'friendships#notifications', as: 'notifications_friendship'
      resources :friendships do
        member do
          post '/accept', to: 'friendships#accept', as: 'accept'
          post '/reject', to: 'friendships#reject', as: 'reject'
        end
      end

      get '/stats', to: 'dashboard#stats'
      get '/ranking', to: 'ranking#index'

      resources :users do
        resources :upload_pics
      end
      resources :posts do
        member do
          post '/status', to: "posts#switch_private_status"
          post 'like', to: 'posts#like'
          post 'dislike', to: 'posts#dislike'
          post '/addpicture', to: "posts#add_picture_to_post"
        end
      end
      resources :comments

      resources :achievements do
        member do
          post 'success' => 'achievements#success'
          post 'failure' => 'achievements#failure'
        end
      end

      resources :conversations, only: [:index, :create] do
        resources :messages, only: [:index, :create]
      end
    end
  end

  # Documentation
  resources :apidocs, only: [:index]
end
