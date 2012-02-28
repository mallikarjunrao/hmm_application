require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/coupons_controller'

# Re-raise errors caught by the controller.
class Ownify::CouponsController; def rescue_action(e) raise e end; end

class Ownify::CouponsControllerTest < Test::Unit::TestCase
  fixtures :ownify_coupons

  def setup
    @controller = Ownify::CouponsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = coupons(:first).id
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

    assert_not_nil assigns(:coupons)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:coupon)
    assert assigns(:coupon).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:coupon)
  end

  def test_create
    num_coupons = Coupon.count

    post :create, :coupon => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_coupons + 1, Coupon.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:coupon)
    assert assigns(:coupon).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Coupon.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Coupon.find(@first_id)
    }
  end
end
