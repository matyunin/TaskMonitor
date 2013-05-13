class TasksController < ApplicationController
  @hours = 8

  def new
    @project_id = params[:project_id]
    render :layout => false
  end

  def create
    render :layout => false

    start = params[:start].to_date.to_time.to_i.to_s
    duration = (params[:duration].to_i * 24 * 3600).to_s
    finish = start.to_i + (params[:priority].to_i * duration.to_i) / 100

    @task = Task.new(
        :name         => params[:name],
        :start        => start,
        :finish       => finish,
        :duration     => duration,
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
    durations = {}
    task_ids = []
    timestamp = 0

    tasks = Task.where(:project => project_id)
    common_points = tasks.map {|task| [task.start.to_i]}.uniq!.sort!
    task_ids = tasks.map {|task| [task._id]}
    timestamp = common_points.first

    while task_ids.count > 0 do
      plot = Plot.new(
          :time => timestamp
      )

      tasks_intersects = self::task_intersects(tasks, task_ids, timestamp)

      tasks.each do |task|
        priority = task.priority
        @hours = 1


        plot.priority = self::is_working_day?(timestamp) ? priority : 0
      end

      timestamp += 3600 * 24
    end


    puts common_points.inspect
  end

  def task_intersects(all_tasks, available_ids, timestamp)
    all_tasks.select {|task| task if task.start <= timestamp and available_ids.include? task._id}
  end

  def is_working_day?(timestamp)
    self::working_days(timestamp).include? timestamp
  end

  def working_days(timestamp)
    require 'date'
    ( (Date.strptime(timestamp.to_s,'%s').beginning_of_month)..(Date.strptime(timestamp.to_s,'%s').end_of_month) ).select {|d| (1..5).include?(d.wday) }.map {|t| t.to_time.to_i}
  end
end
