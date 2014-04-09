class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate

  private

  def current_user
    session[:user_id].present?
  end
  def authenticate
    redirect_to login_path unless current_user or controller_name == 'sessions'
  end

  helper_method :current_user
end
