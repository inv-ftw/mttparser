#encoding: utf-8
class SessionsController < ApplicationController

  def new
    render layout: false
  end

  def create
    if USERDATA.first == params[:login].downcase && USERDATA.last == params[:password]
      session[:user_id] = 1
      redirect_to root_url, notice: 'Здравствуйте!'
    else
      redirect_to new_session_path, alert: 'Введены неверные данные!'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Вы вышли!'
  end
end