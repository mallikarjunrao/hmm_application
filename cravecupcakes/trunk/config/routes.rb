ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.

#
#    map.namespace(:ownify) do |admin|
#    admin.resources :orders, :active_scaffold => true
#
#  end
  
		# home page 
  map.connect '/', :controller => "page", :action => "index"
  map.connect '/index', :controller => "page", :action => "index"

  #main links
  map.connect '/about', :controller => "page", :action => "detail", :page_type => "about", :page_slug => "about"
  map.connect '/gallery', :controller => "page", :action => "gallery"
  map.connect '/contact', :controller => "page", :action => "detail", :page_type => "about", :page_slug => "contact"
  map.connect '/seasonal', :controller => "page", :action => "detail", :page_type => "about", :page_slug => "seasonal"
  map.connect '/events', :controller => "page", :action => "detail", :page_type => "about", :page_slug => "events"
  map.connect '/events-more', :controller => "page", :action => "detail", :page_type => "about", :page_slug => "events-more"    
  map.connect '/coffee', :controller => "page", :action => "detail", :page_type => "about", :page_slug => "coffee"
  map.connect '/decorations', :controller => "page", :action => "detail", :page_type => "about", :page_slug => "decorations"
  map.connect '/menu', :controller => "page", :action => "menu"
  map.connect '/cupcake/:slug', :controller => "page", :action => "cupcake", :slug => 'first'
  map.connect '/mini_cupcake/:slug', :controller => "page", :action => "mini_cupcake", :slug => 'first'
  map.connect '/answers', :controller => "page", :action => "answers"
  map.connect '/news', :controller => "page", :action => "news_list"
  map.connect '/care', :controller => "page", :action => "crave_cares"
  map.connect '/article/:page_slug', :controller => "page", :action => "news_detail"
  map.connect '/care/:page_slug', :controller => "page", :action => "care_detail"
  map.connect '/sign_up', :controller => "page", :action => "sign_up"
  map.connect '/sitemap.xml', :controller => "page", :action => "google_site_map"
  map.connect '/menu_download', :controller => "page", :action => "menu_download"
  map.connect '/special_decorations_download', :controller => "page", :action => "special_decorations_download"

  map.connect '/sessions/:token', :controller => "page", :action => "sessions_clear", :token => ''

  map.connect '/pages/:page_type/:page_slug', :controller => "page", :action => "detail"
  #map.connect '/pages/:page_type', :controller => "page", :action => "list"

  map.connect '/order', :controller => "page", :action => "order", :page_type => "order", :page_slug => "order"  
  # Install the default route as the lowest priority.
  #map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id', :action => 'index', :id => nil
  # eqx added delivery
  map.connect '/delivery', :controller => "page", :action => "delivery"
  map.connect '/privacy', :controller => "page", :action => "privacy"
  map.connect '/special_decorations', :controller => "page", :action => "special_decorations"
  map.connect '/:page_slug', :controller => "page", :action => "detail", :page_type => "about"
end
