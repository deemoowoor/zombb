class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    # Support for angular-devise
    respond_to :html, :json

    def create_object(object, params, name)
        respond_to do |format|
            if object.save
                format.html { redirect_to object,
                              notice: '#{name} was successfully created.' }
                format.json { render action: 'show', status: :created, location: object }
            else
                format.html { render action: 'new' }
                format.json { render json: object.errors, status: :unprocessable_entity }
            end
        end
    end

    def update_object(object, params, name)
        respond_to do |format|
            if object.update(params)
                format.html { redirect_to object, notice: '#{name} was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: object.errors, status: :unprocessable_entity }
            end
        end

    end

    def respond_with_unauthorized
        respond_to do |format|
            format.html { redirect_to_back_or_default :alert => 'Access denied' }
            format.json { render json: 'Unauthorized', status: :unauthorized }
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
end
