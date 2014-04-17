class ResultsController < ApplicationController
  def index
    @results = Result.all.order('updated_at DESC')
    @last_run = @results.first.updated_at.localtime
    conditions = {}
    conditions[:item_id] = params[:item] unless params[:item].blank?
    conditions[:shop_id] = params[:shop] unless params[:shop].blank?
    @results = Result.where(conditions)
    @results = @results.joins(:item).where(items: {brand: params[:brand]}) if params[:brand].present?
  end

  def proceed

    #binding.pry
    r = Result.new
    r.get_results(params)
    redirect_to root_path
  end
end
