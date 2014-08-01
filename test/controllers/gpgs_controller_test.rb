require 'test_helper'

class GpgsControllerTest < ActionController::TestCase
  setup do
    @gpg = gpgs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gpgs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gpg" do
    assert_difference('Gpg.count') do
      post :create, gpg: {  }
    end

    assert_redirected_to gpg_path(assigns(:gpg))
  end

  test "should show gpg" do
    get :show, id: @gpg
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gpg
    assert_response :success
  end

  test "should update gpg" do
    patch :update, id: @gpg, gpg: {  }
    assert_redirected_to gpg_path(assigns(:gpg))
  end

  test "should destroy gpg" do
    assert_difference('Gpg.count', -1) do
      delete :destroy, id: @gpg
    end

    assert_redirected_to gpgs_path
  end
end
