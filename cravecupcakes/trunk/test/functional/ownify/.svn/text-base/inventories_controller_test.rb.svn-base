require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/inventories_controller'

# Re-raise errors caught by the controller.
class Ownify::InventoriesController; def rescue_action(e) raise e end; end

class Ownify::InventoriesControllerTest < Test::Unit::TestCase
  fixtures :ownify_inventories

  def setup
    @controller = Ownify::InventoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = inventories(:first).id
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

    assert_not_nil assigns(:inventories)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:inventory)
    assert assigns(:inventory).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:inventory)
  end

  def test_create
    num_inventories = Inventory.count

    post :create, :inventory => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_inventories + 1, Inventory.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:inventory)
    assert assigns(:inventory).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Inventory.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Inventory.find(@first_id)
    }
  end
end
