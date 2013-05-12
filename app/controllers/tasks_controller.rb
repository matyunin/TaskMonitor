class TasksController < ApplicationController
  def new
    render :layout => false
  end

  def create
    render :layout => false
    task = Task.new(:name => 'Brandon')
    task.save!
  end
end
