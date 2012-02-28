require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/sizes_controller'

# Re-raise errors caught by the controller.
class Ownify::SizesController; def rescue_action(e) raise e end; end

class Ownify::SizesControllerTest < Test::Unit::TestCase
  fixtures :ownify_sizes

  def setup
    @controller = Ownify::SizesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = sizes(:first).id
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

    assert_not_nil assigns(:sizes)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:size)
    assert assigns(:size).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:size)
  end

  def test_create
    num_sizes = Size.count

    post :create, :size => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_sizes + 1, Size.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:size)
    assert assigns(:size).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Size.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Size.find(@first_id)
    }
  end
end
