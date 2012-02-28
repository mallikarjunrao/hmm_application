require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/prices_controller'

# Re-raise errors caught by the controller.
class Ownify::PricesController; def rescue_action(e) raise e end; end

class Ownify::PricesControllerTest < Test::Unit::TestCase
  fixtures :ownify_prices

  def setup
    @controller = Ownify::PricesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = prices(:first).id
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

    assert_not_nil assigns(:prices)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:price)
    assert assigns(:price).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:price)
  end

  def test_create
    num_prices = Price.count

    post :create, :price => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_prices + 1, Price.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:price)
    assert assigns(:price).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Price.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Price.find(@first_id)
    }
  end
end
