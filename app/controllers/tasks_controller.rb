class TasksController < ApplicationController
  def new
    render :layout => false
  end

  def create
    render :layout => false
    @task = Task.new(
        :name         => params[:name],
        :start        => params[:start].to_date.to_time.to_i.to_s,
        :duration     => (params[:duration].to_i * 24 * 3600).to_s,
        :priority     => params[:priority],
        :description  => params[:description]
    )
    @task.save!
    #respond_to :json
  end
end
