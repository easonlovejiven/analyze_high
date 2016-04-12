Rails.application.routes.draw do
  root :to =>'admin/sum_messages#index'
  get "/admin" => "admin/users#index"

  devise_for :users, :controllers => { :sessions => "sessions",:registrations => "registrations",:passwords => "passwords",:confirmations => "confirmations" }

  namespace :admin do

    resources :users do
      collection do
        get "/user_password/:id" => "users#password"
        post "/more_user" => "users#more_user"
        post "/change_password/:id" => "users#change_password"
      end
    end    

    resources :sum_messages do 
      collection do
        post "/more_sum_message" => "sum_messages#more_sum_message"
      end
    end

    resources :documents do
      collection do
        post "/more_document" => "documents#more_document"
      end
    end

  end


  # api
  namespace :api do
    namespace :v1 do

      resources :documents
      
    end
  end
  
end
