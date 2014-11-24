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
        unless current_user.admin?
            unless @user == current_user
                redirect_to_back_or_default :alert => 'Access denied.'
            end
        end
    end

    # PATCH/PUT /posts/1
    # PATCH/PUT /posts/1.json
    def update
        respond_to do |format|
            if @user.update(post_params)
                format.html { redirect_to @post, notice: 'User was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
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

    def user_params
        params.require(:user).permit(
            :name, :email, :password, :password_confirmation)
    end
end
