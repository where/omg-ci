class ApplicationController < ActionController::Base
  protect_from_forgery


  def render_not_found(status=:not_found)
    render :json => {:status => status}, :status => status
  end

  def require_user_role
    render_not_found :unauthorized unless current_user.admin? || current_user.user?
  end
end
