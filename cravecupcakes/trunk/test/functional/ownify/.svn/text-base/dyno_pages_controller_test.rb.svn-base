require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/dyno_pages_controller'

# Re-raise errors caught by the controller.
class Ownify::DynoPagesController; def rescue_action(e) raise e end; end

class Ownify::DynoPagesControllerTest < Test::Unit::TestCase
  fixtures :ownify_dyno_pages

  def setup
    @controller = Ownify::DynoPagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = dyno_pages(:first).id
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

    assert_not_nil assigns(:dyno_pages)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:dyno_page)
    assert assigns(:dyno_page).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:dyno_page)
  end

  def test_create
    num_dyno_pages = DynoPage.count

    post :create, :dyno_page => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_dyno_pages + 1, DynoPage.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:dyno_page)
    assert assigns(:dyno_page).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      DynoPage.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DynoPage.find(@first_id)
    }
  end
end
