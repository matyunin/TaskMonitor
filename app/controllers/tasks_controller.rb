class TasksController < ApplicationController
  def new
    @project_id = params[:project_id]
    render :layout => false
  end

  def create
    render :layout => false
    @task = Task.new(
        :name         => params[:name],
        :start        => params[:start].to_date.to_time.to_i.to_s,
        :finish       => '',
        :duration     => (params[:duration].to_i * 24 * 3600).to_s,
        :priority     => params[:priority],
        :project      => params[:project].to_i,
        :description  => params[:description]
    )
    @task.save!
    self::recalc
    #respond_to :json
  end

  def recalc
    tasks = Task.where(:project => 1)
    common_points = tasks.map {|task| [task.start.to_i, task.points.time.to_i]}
  end
end
