require File.dirname(__FILE__) + '/../test_helper'
require 'item_controller'

class ItemController; def rescue_action(e) raise e end; end

class ItemControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = ItemController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
