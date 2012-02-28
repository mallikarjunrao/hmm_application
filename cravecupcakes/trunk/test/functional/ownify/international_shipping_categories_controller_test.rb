require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/international_shipping_categories_controller'

# Re-raise errors caught by the controller.
class Ownify::InternationalShippingCategoriesController; def rescue_action(e) raise e end; end

class Ownify::InternationalShippingCategoriesControllerTest < Test::Unit::TestCase
  fixtures :ownify_international_shipping_categories

  def setup
    @controller = Ownify::InternationalShippingCategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = international_shipping_categories(:first).id
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

    assert_not_nil assigns(:international_shipping_categories)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:international_shipping_category)
    assert assigns(:international_shipping_category).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:international_shipping_category)
  end

  def test_create
    num_international_shipping_categories = InternationalShippingCategory.count

    post :create, :international_shipping_category => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_international_shipping_categories + 1, InternationalShippingCategory.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:international_shipping_category)
    assert assigns(:international_shipping_category).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      InternationalShippingCategory.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      InternationalShippingCategory.find(@first_id)
    }
  end
end
