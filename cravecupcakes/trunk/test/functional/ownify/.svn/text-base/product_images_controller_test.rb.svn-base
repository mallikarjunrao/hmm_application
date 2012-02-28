require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/product_images_controller'

# Re-raise errors caught by the controller.
class Ownify::ProductImagesController; def rescue_action(e) raise e end; end

class Ownify::ProductImagesControllerTest < Test::Unit::TestCase
  fixtures :ownify_product_images

  def setup
    @controller = Ownify::ProductImagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = product_images(:first).id
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

    assert_not_nil assigns(:product_images)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:product_image)
    assert assigns(:product_image).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:product_image)
  end

  def test_create
    num_product_images = ProductImage.count

    post :create, :product_image => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_product_images + 1, ProductImage.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:product_image)
    assert assigns(:product_image).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ProductImage.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ProductImage.find(@first_id)
    }
  end
end
