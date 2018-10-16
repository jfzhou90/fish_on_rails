# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_authentication

  def require_authentication
    redirect_to root_path unless current_user && session[:username]
  end

  def current_user
    @current_user ||= User.find_by(username: session[:username])
  end
end
