require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:sukanta)
    @another_user = users(:amrita)
  end
  
  test "sould redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirected update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not logged in as a wrong user" do
    get :edit, id: @another_user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirected update when not logged in as wrong user" do
    patch :update, id: @another_user, user: { name: @another_user.name, email: @another_user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  test "should redirect following when not looged in" do
    get :following, id: @user.id
    assert_redirected_to login_url
  end
  test "should redirect followers when not looged in" do
    get :followers, id: @user.id
    assert_redirected_to login_url
  end
end
