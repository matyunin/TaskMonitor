class TasksController < ApplicationController
  @hours = 8

  def new
    @project_id = params[:project_id]
    render :layout => false
  end

  def create
    render :layout => false

    @task = Task.new(
        :name         => params[:name],
        :start        => params[:start].to_date.to_time.to_i.to_s,
        :duration     => (params[:duration].to_i * 24 * 3600).to_s,
        :priority     => params[:priority],
        :project      => params[:project].to_i,
        :description  => params[:description],
        :points       => [],
        :plots        => []
    )
    @task.save!

    self::recalculate params[:project].to_i

    #respond_to :json
  end

  def recalculate(project_id)
    tasks = Task.where(:project => project_id)
    common_points = tasks.map {|task| [task.start.to_i]}

    puts common_points.inspect
  end

  def working_days(timestamp)
    require 'date'
    ( (Date.strptime(timestamp,'%s').beginning_of_month)..(Date.strptime(timestamp,'%s').end_of_month) ).select {|d| (1..5).include?(d.wday) }.map {|t| t.to_time.to_i}
  end
end
