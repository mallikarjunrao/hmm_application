require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/addresses_controller'

# Re-raise errors caught by the controller.
class Ownify::AddressesController; def rescue_action(e) raise e end; end

class Ownify::AddressesControllerTest < Test::Unit::TestCase
  fixtures :ownify_addresses

  def setup
    @controller = Ownify::AddressesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = addresses(:first).id
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

    assert_not_nil assigns(:addresses)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:address)
    assert assigns(:address).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:address)
  end

  def test_create
    num_addresses = Address.count

    post :create, :address => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_addresses + 1, Address.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:address)
    assert assigns(:address).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Address.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Address.find(@first_id)
    }
  end
end
