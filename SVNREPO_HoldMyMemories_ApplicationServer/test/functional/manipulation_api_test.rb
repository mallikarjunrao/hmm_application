require File.dirname(__FILE__) + '/../test_helper'
require 'manipulation_controller'

class ManipulationController; def rescue_action(e) raise e end; end

class ManipulationControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = ManipulationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_manipulate
    result = invoke :manipulate
    assert_equal nil, result
  end
end
