class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :your_function

  def your_function
    @controller = controller_name
    @action = action_name
  end
end
