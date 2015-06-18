class GamesController < ApplicationController
  def index
    if params[:query].present?
      @search_results = Game.search(params[:query], page: params[:page])
    else
      @search_results = Game.all.page params[:page]
    end
  end

  def autocomplete
    render json: Game.search(params[:query], operator:"or", limit: 10).map(&:name)
  end
end