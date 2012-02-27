# Be sure to restart your web server when you modify this file.
#  require 'custom_in_place_editing'
# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
 #ENV['RAILS_ENV'] ||= 'production'
require 'thread'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')


	if Gem::VERSION >= "1.3.6"
    module Rails
      class GemDependency
        def requirement
          r = super
          (r == Gem::Requirement.default) ? nil : r
        end
      end
    end
	end


Rails::Initializer.run do |config|

config.plugins = [:white_list, :sanitize_params, :all]

config.action_controller.consider_all_requests_local = false
 config.gem 'datanoise-actionwebservice', :lib => 'actionwebservice'

  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
   # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
   #config.action_controller.session_store = :active_record_store
  #config.action_controller.session = { :key => "hmm_session", :secret =>
#"DRivinginussucksandIflunkedmylicenseagain"
#}
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
	config.gem 'recaptcha'
	#RCC_PUB='6LfGAs0SAAAAABPYdc4CsXzJceExHku1JZAnEYej'
	#RCC_PRIV='6LfGAs0SAAAAAAZwih38g1h54DQVkVF2CBuLAZ5l'
	#ENV['RECAPTCHA_PUBLIC_KEY']  = '6LfGAs0SAAAAABPYdc4CsXzJceExHku1JZAnEYej'
	#ENV['RECAPTCHA_PRIVATE_KEY'] = '6LfGAs0SAAAAAAZwih38g1h54DQVkVF2CBuLAZ5l'
  #staging environment
  ENV['RECAPTCHA_PUBLIC_KEY']  = '6LcGHM0SAAAAAKAOkLjF0rNmIikTn38vVsZTofIm'
	ENV['RECAPTCHA_PRIVATE_KEY'] = '6LcGHM0SAAAAAF5HREasW0tvqygiLHQ3TNYnFtWx'

  # See Rails::Configuration for more options
  config.action_controller.session = { :session_key => "_myapp_session", :secret => "HoldmymemorieswebsiteHoldmymemorieswebsiteHoldmymemorieswebsiteHoldmymemorieswebsiteHoldmymemorieswebsite" }
end


#ENV['RECAPTCHA_PUBLIC_KEY']  = '6LfGAs0SAAAAABPYdc4CsXzJceExHku1JZAnEYej'
#ENV['RECAPTCHA_PRIVATE_KEY'] = '6LfGAs0SAAAAAAZwih38g1h54DQVkVF2CBuLAZ5l'

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below


#ExceptionNotifier.exception_recipients = %w(farooq@hysistechnologies.com)
#require 'ruby-recaptcha'
#require 'app/vo/Content'
#MemoryProfiler.start
