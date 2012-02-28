require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/product_types_controller'

# Re-raise errors caught by the controller.
class Ownify::ProductTypesController; def rescue_action(e) raise e end; end

class Ownify::ProductTypesControllerTest < Test::Unit::TestCase
  fixtures :ownify_product_types

  def setup
    @controller = Ownify::ProductTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = product_types(:first).id
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

    assert_not_nil assigns(:product_types)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:product_type)
    assert assigns(:product_type).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:product_type)
  end

  def test_create
    num_product_types = ProductType.count

    post :create, :product_type => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_product_types + 1, ProductType.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:product_type)
    assert assigns(:product_type).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ProductType.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ProductType.find(@first_id)
    }
  end
end
