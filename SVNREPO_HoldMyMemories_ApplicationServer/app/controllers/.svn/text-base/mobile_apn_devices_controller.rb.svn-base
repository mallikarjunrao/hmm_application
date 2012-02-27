class MobileApnDevicesController < ApplicationController
  require 'json/pure'
  before_filter :response_header # add json header to the output
  layout false

  def response_header
    response.headers['Pragma' ] = 'no-cache'
    response.headers['Cache-Control' ] = 'no-store, no-cache, max-age=0, must-revalidate'
    response.headers['Content-Type' ] = 'text/x-json'
  end

  
end
