require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/brands_controller'

# Re-raise errors caught by the controller.
class Ownify::BrandController; def rescue_action(e) raise e end; end

class Ownify::BrandControllerTest < Test::Unit::TestCase
  fixtures :ownify_brands

  def setup
    @controller = Ownify::BrandController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = brands(:first).id
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

    assert_not_nil assigns(:brands)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:brands)
    assert assigns(:brands).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:brands)
  end

  def test_create
    num_brands = Brand.count

    post :create, :brands => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_brands + 1, Brand.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:brands)
    assert assigns(:brands).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Brand.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Brand.find(@first_id)
    }
  end
end
