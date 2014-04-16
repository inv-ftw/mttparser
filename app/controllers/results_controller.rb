class ResultsController < ApplicationController
  def index
    @results = Result.all
  end

  def proceed

  end
end
