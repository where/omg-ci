class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_user_role
  before_filter :require_current_project, :only => :destroy

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(params[:project])

    if @project.valid?
      redirect_to projects_path
    else
      render :new, :status => :unprocessable_entity
    end
  end

  def destroy
    current_project.destroy
    redirect_to projects_path
  end

  private
  helper_method :current_project
  def current_project
    @current_project ||= Project.find_by_id(params[:id])
  end

  def require_current_project
    render_not_found unless current_project
  end
end
