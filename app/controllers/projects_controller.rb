class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @projects = @user.projects
  end
end
