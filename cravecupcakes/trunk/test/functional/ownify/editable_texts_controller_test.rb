require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/editable_texts_controller'

# Re-raise errors caught by the controller.
class Ownify::EditableTextsController; def rescue_action(e) raise e end; end

class Ownify::EditableTextsControllerTest < Test::Unit::TestCase
  fixtures :ownify_editable_texts

  def setup
    @controller = Ownify::EditableTextsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = editable_texts(:first).id
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

    assert_not_nil assigns(:editable_texts)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:editable_text)
    assert assigns(:editable_text).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:editable_text)
  end

  def test_create
    num_editable_texts = EditableText.count

    post :create, :editable_text => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_editable_texts + 1, EditableText.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:editable_text)
    assert assigns(:editable_text).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      EditableText.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      EditableText.find(@first_id)
    }
  end
end
