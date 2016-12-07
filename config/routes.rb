Rails.application.routes.draw do

root to: 'pages#welcome'

devise_for :users, :controllers => { registrations: 'users/registrations' }

resources :users do
  resources :user_training_sessions
  collection {post :import}
  get '/billing' => 'users#billing', as: 'billing'
  get '/reservations' => 'users#reservations', as: 'reservations'
  get '/range-waiver' => 'users#waiver', as: 'waiver'
end

resources :waivers, except: [:edit]
resources :payments
resources :master_reservations
resources :orders
resources :order_items
resources :order_item_options
resources :menu_item_options
resources :gun_ranges do
  get '/calendar' => 'gun_ranges#calendar', as: 'calendar'

  resources :lanes
end


 ##### STATIC PAGES ####
 get '/gtr-events' => 'pages#events', as: 'events'
 get '/verify_existing_user' => 'users#verify_existing_user', as: 'verify_existing_user'
 get '/link_account' => 'users#link_account', as: 'link_account'
 get '/checkin' => 'pages#checkin', as: 'checkin'
 get '/master_checkin' => 'pages#master_checkin', as: 'master_checkin'
 get '/todays_reservations' => 'pages#todays_reservations', as: 'todays_reservations'
 get '/under_construction' => 'under_construction#under_construction', as: 'under_construction'

 #### HOOKS######
 post '/member_reservation' => "users#member_reservation"



 get '/about' => 'pages#about', as: 'about'
 get '/firearm-training' => 'pages#firearm_training', as: 'firearm_training'
 get '/franks_cafe' => 'pages#franks_cafe', as: 'franks_cafe'
 get '/confirm_order' => 'pages#confirm_order', as: 'confirm_order'
 get '/gtr-instructors' => 'instructors#index', as: 'instructors'
 get '/gtr-instructors/:id' => 'instructors#show', as: 'instructor'
 get '/show_membership_details' => 'pages#show_membership_details', as: 'show_membership_details'
 post '/stripe_webhooks' => 'pages#stripe_webhooks', as: 'stripe_webhooks'


 ##### APPLY FOR MEMBERSHIP #####################
 get '/apply' => "pages#apply", as: 'apply'
 get '/confirm_reservation' => 'reservations#confirm_reservation', as: 'confirm_reservation'




##### REGISTER CLASS USER FACING ######
get '/training_sessions/:id/show_details' => 'training_sessions#show_details', as: 'training_session_details'
get '/training_classes/:id' => 'training_classes#show', as: 'training_class'
get '/training_sessions/:id' => 'training_sessions#show', as: 'training_session'
get '/training_sessions' => 'training_sessions#index', as: 'training_sessions'
########################################
get '/training_classes' => 'training_classes#index', as: 'training_classes'
get '/calendar' => 'training_sessions#calendar', as: 'calendar'


 namespace :admin do
  resources :events
  resources :users
  resources :training_classes
  resources :deluxe_packages
  resources :training_sessions
  resources :menu_categories
  resources :menu_items
  resources :master_reservations, only: [:create, :index]
  resources :user_training_sessions
  resources :orders
  resources :announcements
  resources :instructors
  resources :memberships
  resources :homepage_videos
  get '/member_list' => 'pages#member_list', as: 'member_list'
  get '/homepage_video' => 'pages#homepage_video', as: 'change_homepage_video'
  get '/create_reservation' => 'pages#create_reservation', as: 'create_reservation'
  get '/select_range' => 'gun_ranges#select_range', as: 'select_range'
  resources :gun_ranges do
    get '/calendar' => 'gun_ranges#calendar', as: 'calendar'
    resources :lanes
  end


  get '/calendar' => 'training_sessions#calendar', as: 'calendar'
  get '/dashboard' => 'pages#dashboard', as: 'dashboard'
  get '/franks_cafe' => 'pages#franks_cafe', as: 'franks_cafe'
 end




end
