class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @projects = @user.projects
    @tasks = Task.where(:project.in => @projects.collect {|p| p.id}.to_a)
  end

  def invite
    render :layout => false
  end

  def invite_save
    render :layout => false

    @project = Project.find(params[:id])
    @user = User.find_by_email(params[:email])

    unless @user.nil? or @project.users.include?(@user)
      @project.users << @user
      @project.save!
    end
  end

  def new
    render :layout => false
  end

  def create
    render :layout => false

    @project = Project.new(
        :name         => params[:name],
        :description  => params[:description]
    )
    @project.users << current_user
    @project.save!
  end

  def show
    require 'json'

    @user = current_user
    @projects = @user.projects
    @project = Project.find(params[:id])
    @tasks = Task.where(:project => @project.id)

    time_bounds = @tasks.map {|t| [t.start.to_i, t.finish.to_i]}
    time_bounds.flatten!
    time_bounds.uniq!
    time_bounds.sort!
    
    @time_interval = {
      :start  => time_bounds.min,
      :finish => time_bounds.max
    }

    @json_tasks = @tasks.to_json(:include => [:plots])
    @json_time_interval = @time_interval.to_json

    p = ApplicationController::TasksController.new
    p::recalculate(@project.id)
    
  end
end
