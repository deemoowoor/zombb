class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    #before_action :admin_only, :except => [:show]

    # GET /users
    # GET /users.json
    def index
        @users = User.all
    end

    # GET /users/1
    # GET /users/1.json
    def show
        unless current_user.admin?
            unless @user == current_user
                redirect_to_back_or_default :alert => 'Access denied.'
            end
        end
    end

    private

    def redirect_to_back_or_default(default = root_url, alert = nil)
        if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
            redirect_to :back, :alert => alert
        else
            redirect_to default, :alert => alert
        end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    def admin_only
        unless current_user.admin?
            redirect_to_back_or_default :alert => 'Access denied.'
        end
    end

    def user_params
        params.require(:user).permit(
            :name, :email, :password, :password_confirmation)
    end
end
