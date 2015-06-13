class DlcsController < ApplicationController
  def index
    if params[:query].present?
      @search_results = Dlc.search(params[:query], page: params[:page])
    else
      @search_results = Dlc.all.page params[:page]
    end
  end

  def autocomplete
    render json: Dlc.search(params[:query], autocomplete: true, limit: 10).map(&:name)
  end
end