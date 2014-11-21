require 'test_helper'

class UsersControllerTest < ActionController::TestCase
    setup do
        @user = users(:reader)
        @user.password = 'testtesttest'

        @admin = users(:admin)
        #@admin.password = 'testtesttest'

        request.env['HTTP_REFERER'] = '/'
    end

    teardown do
        sign_out @admin
        sign_out @user
        @user.delete
    end

    test "should get index when admin" do
        sign_in @admin
        get :index
        assert_response :success
        assert_not_nil assigns(:users)
    end

    test "should show user when admin" do
        sign_in @admin
        get :show, id: @user
        assert_response :success
    end

    test "should show user when same user" do
        sign_in @user
        get :show, id: @user
        assert_response :success
    end

    test "should redirect to login from index when not signed in" do
        get :index
        assert_redirected_to new_user_session_path
    end

    test "should redirect to login from show when not signed in" do
        get :show, id: @user
        assert_redirected_to new_user_session_path
    end
end
