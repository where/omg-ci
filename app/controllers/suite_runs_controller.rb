class SuiteRunsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_user_role
  before_filter :require_current_suite_run
 
  def show

  end

  private
  helper_method :current_suite_run
  def current_suite_run
    @suite_run ||= SuiteRun.find_by_id(params[:id])
  end
  def require_current_suite_run
    render_not_found unless current_suite_run
  end
end
