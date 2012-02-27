require File.dirname(__FILE__) + '/../test_helper'
require 'sub_chapter_controller'

# Re-raise errors caught by the controller.
class SubChapterController; def rescue_action(e) raise e end; end

class SubChapterControllerTest < Test::Unit::TestCase
  fixtures :sub_chapters

  def setup
    @controller = SubChapterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = sub_chapters(:first).id
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

    assert_not_nil assigns(:sub_chapters)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:sub_chapter)
    assert assigns(:sub_chapter).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:sub_chapter)
  end

  def test_create
    num_sub_chapters = SubChapter.count

    post :create, :sub_chapter => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_sub_chapters + 1, SubChapter.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:sub_chapter)
    assert assigns(:sub_chapter).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      SubChapter.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      SubChapter.find(@first_id)
    }
  end
end
