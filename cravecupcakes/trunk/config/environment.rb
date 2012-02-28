# gem 'activesupport','=1.4.4'
#require 'activesupport'
# gem 'activerecord','=1.15.6'
#require 'activerecord'
#gem 'actionpack','=1.13.6'
#require 'actionpack'
#require 'action_controller'
#require 'action_mailer'
#require 'action_web_service'
require 'lib/delegating_attributes.rb'
#require 'active_merchant'
#require 'mysql'
gem 'soap4r'
# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present

 RAILS_GEM_VERSION = '2.3.2' # unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
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
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

 config.active_record.default_timezone = "Central Time (US & Canada)"

  #config.action_controller.session_store = :active_record_store
  #config.action_controller.session = {
  #  :session_key => '_Medical_Portal_session',
  #  :secret      => '92a97cd7e261c14bd6c0773b36a105a72fe8b67c6b557c192db8b700ff65ea97c8d4ccd4e872b19b9f144759b2b9f2b7b27077728162c1d46b104fe773045346'
  #}

  # See Rails::Configuration for more options
end

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


# imagemagick params
IMAGE_ROOT = File.join(RAILS_ROOT, "public/images")
PERMISSIONS = 0744

ActionController::Base.fragment_cache_store = :file_store, File.join(RAILS_ROOT, '/tmp/cache/')
ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update(:database_manager => CGI::Session::ActiveRecordStore)

# time stuff
HALF_HOUR_TIMES = [['12:00am',0],['12:30am',1],['1:00am',2],['1:30am',3],['2:00am',4],['2:30am',5],['3:00am',6],['3:30am',7],['4:00am',8],['4:30am',9],['5:00am',10],['5:30am',11],['6:00am',12],['6:30am',13],['7:00am',14],['7:30am',15],['8:00am',16],['8:30am',17],['9:00am',18],['9:30am',19],['10:00am',20],['10:30am',21],['11:00am',22],['11:30am',23],['12:00pm',24],['12:30pm',25],['1:00pm',26],['1:30pm',27],['2:00pm',28],['2:30pm',29],['3:00pm',30],['3:30pm',31],['4:00pm',32],['4:30pm',33],['5:00pm',34],['5:30pm',35],['6:00pm',36],['6:30pm',37],['7:00pm',38],['7:30pm',39],['8:00pm',40],['8:30pm',41],['9:00pm',42],['9:30pm',43],['10:00pm',44],['10:30pm',45],['11:00pm',46],['11:30pm',47]]

DEFAULT_START = 17
DEFAULT_END = 39

# times for each day first time is sunday.
PICKUP_START_DATES = [21,17,17,17,17,17,19]
PICKUP_END_DATES = [37,39,39,39,39,39,39]

DELIVERY_START = 19
DELIVERY_END = 34

#if session[:user_name]
#  DELIVERY_START = [21,17,17,17,17,17,19]
#  DELIVERY_END = [37,39,39,39,39,39,39]
#
#end