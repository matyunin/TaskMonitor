class TasksController < ApplicationController
  def new
    puts params.inspect
    render :layout => false
  end

  def create
    MongoMapper
  end
end
