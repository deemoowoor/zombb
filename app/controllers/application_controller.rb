class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    # Support for angular-devise
    respond_to :html, :json

    def respond_with_unauthorized
        respond_to do |format|
            format.html { redirect_to_back_or_default :alert => 'Access denied' }
            format.json { render 'Unauthorized', status: :unauthorized }
        end
    end

    def owner_or_admin
        unless (current_user.admin? or current_user == @user)
            respond_with_unauthorized
        end
    end

    def editor_or_admin
        unless (current_user.admin? or current_user.editor?)
            respond_with_unauthorized
        end
    end

    def admin_only
        unless current_user.admin?
            respond_with_unauthorized
        end
    end

    def redirect_to_back_or_default(default = root_url, alert = nil)
        if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
            redirect_to :back, :alert => alert
        else
            redirect_to default, :alert => alert
        end
    end

end
