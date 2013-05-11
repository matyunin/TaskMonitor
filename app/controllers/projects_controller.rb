class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    puts current_user.to_yaml
  end
end
