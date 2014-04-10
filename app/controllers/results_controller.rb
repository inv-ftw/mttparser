class ResultsController < ApplicationController
  def index
    @results = Result.all
  end

  def edit
  end
end
