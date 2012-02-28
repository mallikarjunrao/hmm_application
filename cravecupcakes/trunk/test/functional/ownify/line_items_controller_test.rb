require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/line_items_controller'

# Re-raise errors caught by the controller.
class Ownify::LineItemsController; def rescue_action(e) raise e end; end

class Ownify::LineItemsControllerTest < Test::Unit::TestCase
  fixtures :ownify_line_items

  def setup
    @controller = Ownify::LineItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = line_items(:first).id
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

    assert_not_nil assigns(:line_items)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:line_item)
    assert assigns(:line_item).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:line_item)
  end

  def test_create
    num_line_items = LineItem.count

    post :create, :line_item => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_line_items + 1, LineItem.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:line_item)
    assert assigns(:line_item).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      LineItem.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      LineItem.find(@first_id)
    }
  end
end
