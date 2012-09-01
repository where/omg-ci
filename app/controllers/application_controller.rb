class ApplicationController < ActionController::Base
  protect_from_forgery


  def render_not_found(status=:not_found)
    render :json => {:status => status}, :status => status
  end
end
