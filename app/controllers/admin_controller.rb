class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin


  protected

  def require_admin
    render_not_found :unauthorized unless current_user.admin?
  end

end
