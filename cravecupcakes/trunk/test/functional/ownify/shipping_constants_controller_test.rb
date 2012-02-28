require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/shipping_constants_controller'

# Re-raise errors caught by the controller.
class Ownify::ShippingConstantsController; def rescue_action(e) raise e end; end

class Ownify::ShippingConstantsControllerTest < Test::Unit::TestCase
  fixtures :ownify_shipping_constants

  def setup
    @controller = Ownify::ShippingConstantsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = shipping_constants(:first).id
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

    assert_not_nil assigns(:shipping_constants)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:shipping_constant)
    assert assigns(:shipping_constant).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:shipping_constant)
  end

  def test_create
    num_shipping_constants = ShippingConstant.count

    post :create, :shipping_constant => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_shipping_constants + 1, ShippingConstant.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:shipping_constant)
    assert assigns(:shipping_constant).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ShippingConstant.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ShippingConstant.find(@first_id)
    }
  end
end
