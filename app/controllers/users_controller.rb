class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show]
    before_action :owner_or_admin, only: [:show]
    before_action :admin_only, only: [:index]

    # GET /users
    # GET /users.json
    def index
        @users = User.all
    end

    # GET /users/1
    # GET /users/1.json
    def show
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(
            :name, :email, :password, :password_confirmation)
    end
end
