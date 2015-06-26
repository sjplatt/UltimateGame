class GamesController < ApplicationController
  def index
    if params[:query].present?
      @search_results = Game.search(params[:query],fields: [:name],page: params[:page])
    else
      @search_results = Game.all.page params[:page]
    end
  end

  def autocomplete
    render json: Game.search(params[:query], misspellings: {distance: 1}, highlight: false,partial: true, fields: [{name: :word_start}], limit: 10).map(&:name)
  end
end