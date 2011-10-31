BicingStats::Application.routes.draw do
  resources :stations do
    resources :samples
  end

  root :to => "frontpage#index"
end
