class PackagesController < ApplicationController
  def index
    if params[:query].present?
      @search_results = Package.search(params[:query], page: params[:page])
    else
      @search_results = Package.all.page params[:page]
    end
  end

  def autocomplete
    render json: Package.search(params[:query], autocomplete: true, limit: 10).map(&:name)
  end
end