class DlcsController < ApplicationController
  def index
    if params[:query].present?
      @search_results = Dlc.search(params[:query],fields: [:name],page: params[:page])
    else
      @search_results = Dlc.all.page params[:page]
    end
  end

  def autocomplete
    render json: Dlc.search(
      params[:query],
      misspellings: {distance: 1},
      highlight: false,
      partial: true,
      fields: [{name: :word_start}],
      limit: 10).map {|result| {name: result.name, img: result.headerimg}}
  end
end