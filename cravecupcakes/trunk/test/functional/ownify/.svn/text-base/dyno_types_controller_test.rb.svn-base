require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/dyno_types_controller'

# Re-raise errors caught by the controller.
class Ownify::DynoTypesController; def rescue_action(e) raise e end; end

class Ownify::DynoTypesControllerTest < Test::Unit::TestCase
  fixtures :ownify_dyno_types

  def setup
    @controller = Ownify::DynoTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = dyno_types(:first).id
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

    assert_not_nil assigns(:dyno_types)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:dyno_type)
    assert assigns(:dyno_type).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:dyno_type)
  end

  def test_create
    num_dyno_types = DynoType.count

    post :create, :dyno_type => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_dyno_types + 1, DynoType.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:dyno_type)
    assert assigns(:dyno_type).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      DynoType.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DynoType.find(@first_id)
    }
  end
end
