require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/wish_lists_controller'

# Re-raise errors caught by the controller.
class Ownify::WishListsController; def rescue_action(e) raise e end; end

class Ownify::WishListsControllerTest < Test::Unit::TestCase
  fixtures :ownify_wish_lists

  def setup
    @controller = Ownify::WishListsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = wish_lists(:first).id
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

    assert_not_nil assigns(:wish_lists)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:wish_list)
    assert assigns(:wish_list).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:wish_list)
  end

  def test_create
    num_wish_lists = WishList.count

    post :create, :wish_list => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_wish_lists + 1, WishList.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:wish_list)
    assert assigns(:wish_list).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      WishList.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      WishList.find(@first_id)
    }
  end
end
