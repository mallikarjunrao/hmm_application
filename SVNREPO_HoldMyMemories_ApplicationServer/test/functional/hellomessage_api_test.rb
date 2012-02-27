require File.dirname(__FILE__) + '/../test_helper'
require 'hellomessage_controller'

class HellomessageController; def rescue_action(e) raise e end; end

class HellomessageControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = HellomessageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_hello_message
    result = invoke :hello_message
    assert_equal nil, result
  end
end
