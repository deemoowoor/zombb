class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :admin_only, :except => [:show]

    # GET /users
    # GET /users.json
    def index
        @users = User.all
    end

    # GET /users/1
    # GET /users/1.json
    def show
        unless current_user.admin? or @user == current_user
            redirect_to_back_or_default :alert => 'Access denied.'
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    def admin_only
        unless current_user.admin?
            redirect_to_back_or_default :alert => 'Access denied.'
        end
    end

    def owner_or_admin_only
        unless current_user.admin? or current_user == @user
            redirect_to_back_or_default :alert => 'Access denied.'
        end
    end

    def user_params
        params.require(:user).permit(
            :name, :email, :password, :password_confirmation)
    end
end
