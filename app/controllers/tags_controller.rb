class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def edit
  end
end
