require File.dirname(__FILE__) + '/../test_helper'
require 'customers_controller'

# Re-raise errors caught by the controller.
class CustomersController; def rescue_action(e) raise e end; end

class CustomersControllerTest < Test::Unit::TestCase
  fixtures :hmm_users

  def setup
    @controller = CustomersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = hmm_users(:first).id
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

    assert_not_nil assigns(:hmm_users)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:hmm_user)
    assert assigns(:hmm_user).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:hmm_user)
  end

  def test_create
    num_hmm_users = HmmUser.count

    post :create, :hmm_user => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_hmm_users + 1, HmmUser.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:hmm_user)
    assert assigns(:hmm_user).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      HmmUser.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      HmmUser.find(@first_id)
    }
  end
end
