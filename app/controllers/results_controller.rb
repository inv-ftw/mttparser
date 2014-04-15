class ResultsController < ApplicationController
  def index
    @results = Result.all.order(:shop_id)
  end

  def edit
  end
end
