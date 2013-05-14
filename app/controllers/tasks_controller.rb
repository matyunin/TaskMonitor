class TasksController < ApplicationController
  @@hours = 8

  def new
    @project_id = params[:project_id]
    render :layout => false
  end

  def create
    render :layout => false

    start = params[:start].to_date.to_time.to_i.to_s
    duration = (params[:duration].to_i * 8 * 3600).to_s
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
  end

  def recalculate(project_id)
    durations = {}
    task_ids = []
    timestamp = 0

    tasks = Task.where(:project => project_id)

    tasks.each do |task|
      task.plots.delete_all
      task.save!
    end

    common_points = tasks.map {|task| task.start.to_i}
    common_points.uniq!
    common_points.sort!

    task_ids = tasks.map {|t| t.id.to_s}
    timestamp = common_points.min

    while task_ids.count > 0 do
      tasks_intersects = self::task_intersects(tasks, task_ids, timestamp)

      tasks_intersects.each do |task|
        priority = self::rel_priority(task, tasks_intersects)
        priority = self::is_working_day?(timestamp) ? priority : 0 
	      estimiate_time = task.duration.to_i - durations[task.id.to_s].to_i
        available_time = (@@hours * 3600 * priority / 100).to_i
        	
        #raise priority.to_yaml

        if estimiate_time <= available_time
          priority = priority * estimiate_time / available_time
          durations.delete task.id.to_s
          task_ids.delete_if {|v| v == task.id.to_s}
        else
          durations[task.id.to_s] = durations[task.id.to_s].to_i + available_time   
        end 

        plot = Plot.create(
          :time     => timestamp,
          :priority => priority
        )

	      task.finish = timestamp
        task.plots << plot
        task.save!
      end
      
      timestamp += 3600 * 24
    end
  end

  def rel_priority(task, all_tasks)
    (task.priority.to_i * 100).to_f / all_tasks.map {|task| task.priority.to_i}.inject {|sum,x| sum + x }.to_f
  end

  def task_intersects(all_tasks, available_ids, timestamp)
    #raise timestamp.to_yaml 
    #raise all_tasks.map {|task| task.start.to_i}.to_yaml
    #raise timestamp.to_yaml
    all_tasks.select {|task| task if task.start.to_i <= timestamp and available_ids.include? task.id.to_s}
  end

  def is_working_day?(timestamp)
    self::working_days(timestamp).include? timestamp
  end

  def working_days(timestamp)
    require 'date'
    ( (Date.strptime(timestamp.to_s,'%s').beginning_of_month)..(Date.strptime(timestamp.to_s,'%s').end_of_month) ).select {|d| (1..5).include?(d.wday) }.map {|t| t.to_time.to_i}
  end
end
