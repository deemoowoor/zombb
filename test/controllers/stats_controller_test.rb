require 'test_helper'

class StatsControllerTest < ActionController::TestCase
    setup do
        @reader = users(:reader)
        @user = users(:editor)
        @admin = users(:admin)
    end

    test "should respond with unauthorized if accessed by non admin" do
        sign_in @user
        get :index, format: 'json'
        assert_response :unauthorized
    end

    test "should respond with data if accessed by admin" do
        sign_in @admin
        get :index, format: 'json'
        assert_response :success
    end
end
