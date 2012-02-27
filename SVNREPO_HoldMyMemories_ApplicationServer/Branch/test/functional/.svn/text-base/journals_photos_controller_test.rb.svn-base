require File.dirname(__FILE__) + '/../test_helper'
require 'journals_photos_controller'

# Re-raise errors caught by the controller.
class JournalsPhotosController; def rescue_action(e) raise e end; end

class JournalsPhotosControllerTest < Test::Unit::TestCase
  fixtures :journals_photos

  def setup
    @controller = JournalsPhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = journals_photos(:first).id
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

    assert_not_nil assigns(:journals_photos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:journals_photo)
    assert assigns(:journals_photo).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:journals_photo)
  end

  def test_create
    num_journals_photos = JournalsPhoto.count

    post :create, :journals_photo => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_journals_photos + 1, JournalsPhoto.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:journals_photo)
    assert assigns(:journals_photo).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      JournalsPhoto.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      JournalsPhoto.find(@first_id)
    }
  end
end
