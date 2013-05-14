class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @projects = @user.projects
    @tasks = Task.where(:project.in => @projects.collect {|p| p.id}.to_a)
  end

  def show
    require 'json'

    @user = current_user
    @projects = @user.projects
    @project = Project.find(params[:id])
    @tasks = Task.where(:project => @project.id)
    
    time_bounds = @tasks.map {|t| [t.start, t.finish]}
    time_bounds.uniq!
    time_bounds.sort!
    time_bounds.flatten!
    
    @time_interval = {
      :start  => time_bounds.first.to_i,
      :finish => time_bounds.last.to_i
    }

    @json_tasks = @tasks.to_json
    @json_time_interval = @time_interval.to_json
    #raise time_interval.to_yaml
  end
end
