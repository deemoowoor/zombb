class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Support for angular-devise
  respond_to :html, :json

  def redirect_to_back_or_default(default = root_url, alert = nil)
      if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
          redirect_to :back, :alert => alert
      else
          redirect_to default, :alert => alert
      end
  end

end
