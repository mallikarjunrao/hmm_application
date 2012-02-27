require File.dirname(__FILE__) + '/../test_helper'
require 'advertisers_controller'

# Re-raise errors caught by the controller.
class AdvertisersController; def rescue_action(e) raise e end; end

class AdvertisersControllerTest < Test::Unit::TestCase
  fixtures :advertiser_details

  def setup
    @controller = AdvertisersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = advertiser_details(:first).id
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

    assert_not_nil assigns(:advertiser_details)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:advertiser_details)
    assert assigns(:advertiser_details).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:advertiser_details)
  end

  def test_create
    num_advertiser_details = AdvertiserDetails.count

    post :create, :advertiser_details => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_advertiser_details + 1, AdvertiserDetails.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:advertiser_details)
    assert assigns(:advertiser_details).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      AdvertiserDetails.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      AdvertiserDetails.find(@first_id)
    }
  end
end
