Rails.application.routes.draw do


  devise_for :admins

  resources :join
  get 'admin', to: 'admin/login#index'

  namespace :admin do
    resources :view_users
    resources :view_groups
    resources :view_polls

    get 'view_groups', to: 'view_groups#index'
    get 'view_groups/:id', to: 'view_groups#destroy'
    get 'search_polls', to: 'view_polls#poll_search'
    get 'groups_admin', to: 'view_groups#admin_groups'


  end

  get 'notifications', to: 'notifications#index'

  resources :notifications, only: [:index, :destroy]
  get 'notifications/read'
  get 'polls/read'
  get 'polls/comment_read'
  get 'search', to: 'search#index'
  put 'groups/:id/revoke', to: 'groups#revoke'
  get 'check-username', to: 'users#check_username'
  resources :comments, only: [:create, :index, :destroy]
  post 'vote', to: 'votes#vote'
  resources :polls, except: [:edit, :new]
  post 'polls/:id', to: 'polls#update'
  resources :user_contacts
  resources :users, only: [:show, :index]
  post 'user_contacts/sync', to: 'user_contacts#sync'
  resources :blocked_contacts, only: [:index, :destroy, :create]
  root to: 'home#index'

  get 'list_polls/media_disabled', to: 'list_polls#media_disabled'
  get 'list_polls/deleted', to: 'list_polls#deleted'
  post 'list_polls/restore', to: 'list_polls#restore'
  get 'list_groups/deleted', to: 'list_groups#deleted'
  post 'list_groups/restore', to: 'list_groups#restore'
  get 'list_users/deleted', to: 'list_users#deleted'
  post 'list_users/restore', to: 'list_users#restore'

  resources :dashboard, defaults: {format: :html} do
  end
  resources :list_users, defaults: {format: :html} do
  end
  resources :list_groups, defaults: {format: :html} do
  end
  resources :list_polls, defaults: {format: :html} do
  end

  resources :generic_groups, defaults: {format: :html} do
  end
  post 'list_groups/1', to: 'generic_groups#create'

  resources :broadcast_messages, defaults: {format: :html} do
  end
  resources :groups, defaults: {format: :json} do


    member do
      get :polls
      post 'poll_read', to: 'polls#poll_read'

    end
    resources :users, defaults: {format: :json}, controller: 'group_users' do
      collection do
        post 'bulk_add', to: 'group_users#bulk_add'
        get 'blocked', to: 'group_users#blocked'
      end
    end
  end
  delete '/groups/:id/image', to: 'groups#delete_image'
  delete '/profile/:id/image', to: 'profiles#delete_image'
  delete '/polls/:id/composite', to: 'polls#delete_composite'
  delete '/polls/:id/image1', to: 'polls#delete_image1'
  delete '/polls/:id/image2', to: 'polls#delete_image2'
  delete '/polls/:id/video', to: 'polls#delete_video'

  # delete '/comments', to: 'comments#delete_comments'
  get 'groups/:share_id', to: 'groups#show'
  get '/groups/join_group/:share_id', to: 'share#join_group'
  resource :otp, controller: 'otp', only: [:create, :update]
      delete 'logout', to: 'otp#logout'

  resource :profile, only: [:show, :update], defaults: {format: :json}
end
