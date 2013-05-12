class TasksController < ApplicationController
  def new
    puts params.inspect
    render :layout => false
  end

  def create
    task = Task.new(:name => 'Brandon')
    task.save!
  end
end
