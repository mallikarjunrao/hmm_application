require File.dirname(__FILE__) + '/../test_helper'
require 'journals_audios_controller'

# Re-raise errors caught by the controller.
class JournalsAudiosController; def rescue_action(e) raise e end; end

class JournalsAudiosControllerTest < Test::Unit::TestCase
  fixtures :journals_audios

  def setup
    @controller = JournalsAudiosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = journals_audios(:first).id
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

    assert_not_nil assigns(:journals_audios)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:journals_audio)
    assert assigns(:journals_audio).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:journals_audio)
  end

  def test_create
    num_journals_audios = JournalsAudio.count

    post :create, :journals_audio => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_journals_audios + 1, JournalsAudio.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:journals_audio)
    assert assigns(:journals_audio).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      JournalsAudio.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      JournalsAudio.find(@first_id)
    }
  end
end
