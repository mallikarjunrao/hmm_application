require File.dirname(__FILE__) + '/../test_helper'
require 'hmms_controller'

# Re-raise errors caught by the controller.
class HmmsController; def rescue_action(e) raise e end; end

class HmmsControllerTest < Test::Unit::TestCase
  fixtures :hmms

  def setup
    @controller = HmmsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:hmms)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_hmm
    old_count = Hmm.count
    post :create, :hmm => { }
    assert_equal old_count+1, Hmm.count
    
    assert_redirected_to hmm_path(assigns(:hmm))
  end

  def test_should_show_hmm
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_hmm
    put :update, :id => 1, :hmm => { }
    assert_redirected_to hmm_path(assigns(:hmm))
  end
  
  def test_should_destroy_hmm
    old_count = Hmm.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Hmm.count
    
    assert_redirected_to hmms_path
  end
end
