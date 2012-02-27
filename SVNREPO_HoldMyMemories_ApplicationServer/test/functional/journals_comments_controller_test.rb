require File.dirname(__FILE__) + '/../test_helper'
require 'journals_comments_controller'

# Re-raise errors caught by the controller.
class JournalsCommentsController; def rescue_action(e) raise e end; end

class JournalsCommentsControllerTest < Test::Unit::TestCase
  fixtures :journals_comments

  def setup
    @controller = JournalsCommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = journals_comments(:first).id
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

    assert_not_nil assigns(:journals_comments)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:journals_comment)
    assert assigns(:journals_comment).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:journals_comment)
  end

  def test_create
    num_journals_comments = JournalsComment.count

    post :create, :journals_comment => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_journals_comments + 1, JournalsComment.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:journals_comment)
    assert assigns(:journals_comment).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      JournalsComment.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      JournalsComment.find(@first_id)
    }
  end
end
