ActionController::Routing::Routes.draw do |map|
  map.resources :feeds, :collection => {:ping => :any}
  map.root :controller => 'timeline', :action => 'articles_for'

  map.articles_for ':year/:month/:day', :controller => 'timeline', :action => 'articles_for',
    :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
