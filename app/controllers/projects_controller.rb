class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  def index
    puts YAML::dump(current_user)
  end
end
