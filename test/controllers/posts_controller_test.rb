require 'test_helper'

class PostsControllerTest < ActionController::TestCase
    setup do
        @post = posts(:one)
        @user = users(:reader)
    end

    test "should get index" do
        sign_in @user
        get :index
        assert_response :success
        assert_not_nil assigns(:posts)
    end

    test "should get new" do
        sign_in @user
        get :new
        assert_response :success
    end

    test "should create post" do
        sign_in @user
        assert_difference('Post.count') do
            post :create, post: { body: @post.body, title: @post.title }
        end

        assert_redirected_to post_path(assigns(:post))
    end

    test "should show post" do
        get :show, id: @post
        assert_response :success
    end

    test "should get edit" do
        sign_in @user
        get :edit, id: @post
        assert_response :success
    end

    test "should update post" do
        sign_in @user
        patch :update, id: @post, post: { body: @post.body, title: @post.title }
        assert_redirected_to post_path(assigns(:post))
    end

    test "should destroy post" do
        sign_in @user
        assert_difference('Post.count', -1) do
            delete :destroy, id: @post
        end

        assert_redirected_to posts_path
    end
end
