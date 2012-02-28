require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/cupcakes_controller'

# Re-raise errors caught by the controller.
class Ownify::CupcakesController; def rescue_action(e) raise e end; end

class Ownify::CupcakesControllerTest < Test::Unit::TestCase
  fixtures :ownify_cupcakes

  def setup
    @controller = Ownify::CupcakesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = cupcakes(:first).id
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

    assert_not_nil assigns(:cupcakes)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:cupcake)
    assert assigns(:cupcake).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:cupcake)
  end

  def test_create
    num_cupcakes = Cupcake.count

    post :create, :cupcake => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_cupcakes + 1, Cupcake.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:cupcake)
    assert assigns(:cupcake).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Cupcake.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Cupcake.find(@first_id)
    }
  end
end
