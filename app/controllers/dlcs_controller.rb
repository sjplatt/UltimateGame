class DlcsController < ApplicationController
  def index
    if params[:query].present?
      @search_results = Dlc.search(params[:query], page: params[:page])
    else
      @search_results = Dlc.all.page params[:page]
    end
  end
end