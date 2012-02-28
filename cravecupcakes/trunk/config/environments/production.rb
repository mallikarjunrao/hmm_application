 config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

# Enable the breakpoint server that script/breakpointer connects to
  config.breakpoint_server = true

 HOST = 'cravecupcakes.com'
# Show full error reports and disable caching
 config.action_controller.consider_all_requests_local = true
 config.action_controller.perform_caching             = false # true
 config.action_view.cache_template_extensions         = false
 config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
 config.action_mailer.raise_delivery_errors = false

 ActionMailer::Base.smtp_settings = {
 :address => "mail.cravecupcakes.com",
 :port => 25,
 :authentication => :login,
 :domain => "mail.cravecupcakes.com",
 :user_name => "dont_delete@cravecupcakes.com",
 :password => "UjBrD1e2"
 }

 SERVER_EMAIL = 'dist@equinexus.com'

#require 'cached_model'

 # memcache_options = {
 #  :compression => true,
 #  :debug => false,
 #  :namespace => "mem-#{RAILS_ENV}",
 #  :readonly => false,
 #  :urlencode => false
#}

#memcache_servers = [ 'localhost:11211' ]

#CACHE = MemCache.new(memcache_options)
#CACHE.servers = memcache_servers
#ActionController::Base.session_options[:cache] = CACHE
#config.action_controller.session_store = :mem_cache_store