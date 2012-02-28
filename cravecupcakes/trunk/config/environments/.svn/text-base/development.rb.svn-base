# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
 config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
 config.whiny_nils = true

# Enable the breakpoint server that script/breakpointer connects to
 config.breakpoint_server = true

 HOST = 'cravecupcakes.com'
# Show full error reports and disable caching
 config.action_controller.consider_all_requests_local = true
 config.action_controller.perform_caching             = false #true
 config.action_view.cache_template_extensions         = false
 config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
 config.action_mailer.raise_delivery_errors = false

# ActionMailer::Base.smtp_settings = {
#  :domain    => "mail.cravecupcakes.com",
#  :address    => "mail.cravecupcakes.com",
#  :port      => "25"
# }
config.action_mailer.default_url_options = { :host => 'localhost:3000' }

 ActionMailer::Base.smtp_settings = {
      :enable_starttls_auto => true,
      :address => 'smtp.gmail.com',
      :port => 587,
      :tls  => 'true',
      :domain => 'gmail.com',
      :authentication => :plain,
      :user_name => 'mallikarjunarao5375@gmail.com',
      :password => '9848012345'
      }

 SERVER_EMAIL = 'dist@equinexus.com'