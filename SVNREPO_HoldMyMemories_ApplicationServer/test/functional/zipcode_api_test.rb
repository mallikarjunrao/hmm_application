require File.dirname(__FILE__) + '/../test_helper'
require 'zipcode_controller'

class ZipcodeController; def rescue_action(e) raise e end; end

class ZipcodeControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = ZipcodeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_zipcode
    result = invoke :zipcode
    assert_equal nil, result
  end
end
