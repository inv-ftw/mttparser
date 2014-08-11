class ResultsController < ApplicationController
  def index
    @last_run = Result.all.first.updated_at.localtime.strftime("%H:%M / %d-%m-%Y") if Result.all.first
    respond_to do |format|
      format.html
      format.xls
      format.json { render json: ResultsDatatable.new(view_context, request.referer) }
    end
  end

  def proceed
    #binding.pry
    shops_count = params[:r_shop].present? ? 1 : Shop.count
    items_count = params[:r_item].present? ? params[:r_item].count : Item.count
    cookies[:results_count] = shops_count * items_count
    options = params
    options[:r_item] = params[:r_item].join(',') if params[:r_item].present?
    call_rake(:get_results, options)
    Result.delete_all
    redirect_to root_path
  end

  def results_count
    respond_to do |format|
      format.json {render json: {count: Result.count}}
    end
  end
end
