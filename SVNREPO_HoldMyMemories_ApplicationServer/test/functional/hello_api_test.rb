require File.dirname(__FILE__) + '/../test_helper'
require 'hello_controller'

class HelloController; def rescue_action(e) raise e end; end

class HelloControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = HelloController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_getMsg
    result = invoke :getMsg
    assert_equal nil, result
  end
end
