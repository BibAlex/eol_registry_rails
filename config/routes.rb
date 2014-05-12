EolRegistryRails::Application.routes.draw do
  # TODO: there is no index page yet, so may as well throw a 404
  root :to => 'errors#error_404'
  
#  resources :push_requests, :only => [:create, :show]
#  resources :push_requests do
#    member do
#      post 'create'
#      get 'show'
#    end
#  end
  match '/push_requests/create' => 'push_requests#create'
  match '/push_requests/show' => 'push_requests#show'
#  resource :push_requests do
#    collection do
#      get 'make_push'
#      get 'query'
#    end
#  end

  resource :pull_requests do
    collection do
      get 'pull'
      get 'report'
    end
  end

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
