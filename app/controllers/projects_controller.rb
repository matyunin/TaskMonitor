class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @projects = @user.projects
  end

  def show
    @user = current_user
    @projects = @user.projects
    @project = Project.find(params[:id])
  end
end
