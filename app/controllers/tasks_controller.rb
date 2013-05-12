class TasksController < ApplicationController
  def new
    render :layout => false
  end

  def create
    render :layout => false
    task = Task.new(
        :name         => params[:name],
        :start        => params[:start].to_date.to_time.to_i,
        :duration     => params[:duration] * 24 * 3600,
        :priority     => params[:priority],
        :description  => params[:description]
    )
    task.save!
    respond_to :json
  end
end
