class Admin::UsersController < AdminController 
  before_filter :require_selected_user, :only => [:edit]
  before_filter :require_selected_user_is_not_current_user, :only => [:edit]
  def index
    @users = User.all
  end

  def edit

  end

  private

  helper_method :selected_user
  def selected_user
    @selected_user ||= User.find_by_id(params[:id])
  end

  def require_selected_user
    render_not_found unless selected_user
  end

  def require_selected_user_is_not_current_user
    render_not_found(:bad_request) if current_user.id == selected_user.id
  end
end
