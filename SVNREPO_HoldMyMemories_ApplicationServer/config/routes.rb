ActionController::Routing::Routes.draw do |map|
  map.resources :tests

  #map.resources :invite_friends

  map.resources :share_comments

  map.resources :abuses

  #map.resources :galleries



  map.connect "/", :controller => 'pages', :action => 'index'


  map.index '/:id', :controller => 'familywebsite',
  #map.index '/:id', :controller => 'manage_iphone_studio',
  :action => "home" , :id => %r([^/;,?]+)



#  map.resources :pages

   map.resources :UserSession


map.evelethsfamily 'evelethfamily', :controller => 'evelethsfamily', :action => 'evelethfamily'
map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'


##contests routes
#  map.index '/contests/:action', :controller => 'contests', :action => 'select_contest'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'create_vote'
#  map.connect '/contests/winners/:action', :controller => 'contests', :action => 'previous_contest'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'hmm_contest'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'iphone_contest'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'select_contest_type'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'rules'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'submit_entry'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'create_vote'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'moments_vote'
#  map.connect '/contests/:id/:action', :controller => 'contests', :action => 'videomoment_vote'
#  map.vote '/contests/:id/:action/:moment_id', :controller => 'contests',  :action => 'vote'
#  map.connect '/contests/:id/:action/:contest_type', :controller => 'contests', :action => 'contest_terms_conditions'
#  map.connect '/contests/:id/:action/:contest_type', :controller => 'contests', :action => 'contest_login'
#  map.vote '/contests/:id/:action/moment_id', :controller => 'contests',  :action => 'vote'
#  map.momentdetails '/contests/:id/:action/moment_id', :controller => 'contests',  :action => 'momentdetails'
#  map.momentdetails '/contests/:id/:action/moment_id', :controller => 'contests',  :action => 'videomoment_details'
#  map.authenticate_vote '/contests/:id/:action/unid', :controller => 'contests',  :action => 'authenticate_vote'






  #map.resources :users

  map.resources :accounts




  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end