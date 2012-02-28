require File.dirname(__FILE__) + '/../test_helper'
require 'responses_controller'

# Re-raise errors caught by the controller.
class ResponsesController; def rescue_action(e) raise e end; end

class ResponsesControllerTest < Test::Unit::TestCase
  fixtures :responses

  def setup
    @controller = ResponsesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = responses(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:responses)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:response)
    assert assigns(:response).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:response)
  end

  def test_create
    num_responses = Response.count

    post :create, :response => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_responses + 1, Response.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:response)
    assert assigns(:response).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Response.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Response.find(@first_id)
    }
  end
end
