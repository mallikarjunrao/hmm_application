require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/features_controller'

# Re-raise errors caught by the controller.
class Ownify::FeaturesController; def rescue_action(e) raise e end; end

class Ownify::FeaturesControllerTest < Test::Unit::TestCase
  fixtures :ownify_features

  def setup
    @controller = Ownify::FeaturesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = features(:first).id
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

    assert_not_nil assigns(:features)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:feature)
    assert assigns(:feature).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:feature)
  end

  def test_create
    num_features = Feature.count

    post :create, :feature => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_features + 1, Feature.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:feature)
    assert assigns(:feature).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Feature.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Feature.find(@first_id)
    }
  end
end
