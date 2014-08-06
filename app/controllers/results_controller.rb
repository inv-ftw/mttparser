class ResultsController < ApplicationController
  def index
    #@results = Result.all.order('updated_at DESC')
    @last_run = Result.all.first.updated_at.localtime.strftime("%H:%M / %d-%m-%Y") if Result.all.first
    # conditions = {}
    # conditions[:item_id] = params[:item] unless params[:item].blank?
    # conditions[:shop_id] = params[:shop] unless params[:shop].blank?
    # @results = Result.where(conditions)
    # @results = @results.joins(:item).where(items: {brand: params[:brand]}) if params[:brand].present?

    respond_to do |format|
      format.html
      format.xls
      format.json { render json: ResultsDatatable.new(view_context, request.url) }
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
