class SuitesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_user_role
  before_filter :require_current_suite, :only => [:edit, :destroy, :update]
  before_filter :require_current_project, :only => [:new, :create]
 
  def new
    @suite = current_project.suites.build
  end

  def create
    @suite = current_project.suites.create(params[:suite])

    if @suite.valid?
      redirect_to projects_path
    else
      render :new, :status => :unprocessable_entity
    end
  end

  def edit
  end

  def update
    current_suite.update_attributes(params[:suite])
    if current_suite.valid?
      redirect_to projects_path
    else
      render :edit, :status => :unprocessable_entity
    end
  end

  def destroy
    current_suite.destroy
    redirect_to projects_path
  end

  protected
  helper_method :current_project
  def current_project
    @current_project ||= Project.find_by_id(params[:project_id])
  end

  helper_method :current_suite
  def current_suite
    @current_suite ||= Suite.find_by_id(params[:suite_id] || params[:id])
  end

  def require_current_suite
    render_not_found unless current_suite
  end

  def require_current_project
    render_not_found unless current_project
  end

end