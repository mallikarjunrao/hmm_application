require File.dirname(__FILE__) + '/../test_helper'
require 'journals_videos_controller'

# Re-raise errors caught by the controller.
class JournalsVideosController; def rescue_action(e) raise e end; end

class JournalsVideosControllerTest < Test::Unit::TestCase
  fixtures :journals_videos

  def setup
    @controller = JournalsVideosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = journals_videos(:first).id
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

    assert_not_nil assigns(:journals_videos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:journals_video)
    assert assigns(:journals_video).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:journals_video)
  end

  def test_create
    num_journals_videos = JournalsVideo.count

    post :create, :journals_video => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_journals_videos + 1, JournalsVideo.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:journals_video)
    assert assigns(:journals_video).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      JournalsVideo.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      JournalsVideo.find(@first_id)
    }
  end
end
