Rails.application.routes.draw do
  
  post 'signup', to: 'user#create'
  post 'login', to: 'user#login'
  
  post 'projects', to: 'project#create'
  get 'projects', to: 'project#index'
  get 'projects/performance', to: 'project#allperformance'
  get 'projects/:id/budget', to: 'project#budget'
  get 'projects/:id', to: 'project#show'
  get 'projects/:id/performance', to: 'project#performance'

  post 'blocks', to: 'block#create'
  get 'blocks', to: 'block#index'
  get 'blocks/:id', to: 'block#show'
  delete 'blocks/:id', to: 'block#destroy'

  post 'tasks', to: 'task#create'
  get 'tasks/:id', to: 'task#show'
  patch 'tasks/:id', to: 'task#update'
  patch 'tasks/:id/budget', to: 'task#budget'
  delete 'tasks/:id', to: 'task#destroy'
  
  post 'costs', to: 'cost#create'

  post 'contributor', to: 'project#addcontrib'
  post 'invite', to: 'project#getcontribs'

  get 'dashboard', to: 'user#generalstats'

  post 'service_task/create'
  post 'material_task/create'
  post 'time_task/create'

  post 'islogged', to: 'auth#check_user_status'
  
  get 'account', to: 'user#show'
  patch 'account/cost', to: 'user#updatecost'

  get 'service_task/show'
  get 'service_task/update'
  get 'service_task/destroy'
  get 'material_task/show'
  get 'material_task/update'
  get 'material_task/destroy'
  get 'time_task/show'
  get 'time_task/update'
  get 'time_task/destroy'
  get 'task/update'
  get 'task/destroy'
  get 'task/show'
  get 'block/update'
  get 'block/destroy'
  get 'block/show'
  get 'project/update'
  get 'project/destroy'
  get 'project/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
