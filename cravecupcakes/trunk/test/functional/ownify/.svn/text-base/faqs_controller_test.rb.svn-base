require File.dirname(__FILE__) + '/../../test_helper'
require 'ownify/faqs_controller'

# Re-raise errors caught by the controller.
class Ownify::FaqsController; def rescue_action(e) raise e end; end

class Ownify::FaqsControllerTest < Test::Unit::TestCase
  fixtures :ownify_faqs

  def setup
    @controller = Ownify::FaqsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = faqs(:first).id
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

    assert_not_nil assigns(:faqs)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:faq)
    assert assigns(:faq).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:faq)
  end

  def test_create
    num_faqs = Faq.count

    post :create, :faq => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_faqs + 1, Faq.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:faq)
    assert assigns(:faq).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Faq.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Faq.find(@first_id)
    }
  end
end
