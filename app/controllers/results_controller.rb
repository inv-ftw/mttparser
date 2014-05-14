class ResultsController < ApplicationController
  def index
    @results = Result.all.order('updated_at DESC')
    @last_run = @results.first.updated_at.localtime.strftime("%H:%M / %d-%m-%Y") if @results.first
    conditions = {}
    conditions[:item_id] = params[:item] unless params[:item].blank?
    conditions[:shop_id] = params[:shop] unless params[:shop].blank?
    @results = Result.where(conditions)
    @results = @results.joins(:item).where(items: {brand: params[:brand]}) if params[:brand].present?

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def proceed
    call_rake(:get_results, params)
    Result.delete_all
    redirect_to root_path
  end
end
