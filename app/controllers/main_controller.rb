require 'yaml'
include FrontPage
include PriceInfo
include YoutubeInfo
include GoogleSearch
include RedditInfo

class MainController < ApplicationController

  #Precondition: input_name is the name of the game/DLC/package
  #Precondition: input_is_DLC is true if game is dlc
  #Precondition: input_is_pkg is true if game is a package
  #Postcondition: @associated_names (created if nonexistent) contains an entry with this data
  def add_associated_name(input_name, input_is_DLC, input_is_pkg)
    if !@associated_names
      @associated_names = {}
    end
    @associated_names[input_name] = {is_dlc: input_is_DLC,
                                     is_pkg: input_is_pkg}

    # is_dlc,is_pkg can be:
    # false,false (just the game itself),
    # (sometimes it is listed as a package, so default specifies it as
    #  "the game itself" if this is the case)
    # true,false,
    # false,true
  end

  # POST '/ajax/get_prices'
  def get_prices_ajax
    input_name = params[:input_name]
    item_needed = Game.find_by(name: input_name) ||
                  Dlc.find_by(name: input_name) ||
                  Package.find_by(name: input_name)
    if item_needed
      itad_plain = item_needed.itad

      prices = get_prices(input_name, itad_plain)

      respond_to do |format|
        format.json {render :json => {:results => prices}}
      end
    end
  end

  # POST '/ajax/get_images'
  def get_images_ajax
    input_name = params[:input_name]
    google_image_links = google_image_info(input_name, Time.now)

    respond_to do |format|
      format.json {render :json => {:results => google_image_links}}
    end
  end

  # POST '/ajax/get_videos'
  def get_videos_ajax
    input_name = params[:input_name]

    video_names1, video_links1, video_image_links1 = youtube_info(input_name, " reviews")
    video_names2, video_links2, video_image_links2 = youtube_info(input_name, " gameplay")

    respond_to do |format|
      format.json {render :json => {
        :reviews => {
          :names => video_names1,
          :links => video_links1,
          :image_links => video_image_links1
        },
        :gameplay => {
          :names => video_names2,
          :links => video_links2,
          :image_links => video_image_links2
        }
      }}
    end
  end

  # POST '/ajax/get_extra_info'
  def get_extra_info_ajax
    input_name = params[:input_name]

    item = Dlc.find_by(name:input_name)
    if (item)
      item_hash = {
        name: item.name,
        steamid: item.steamid,
        description: item.description,
        website: item.website,
        releasedate: item.releasedate,
        developer: item.developer.gsub(/(\[\"|\"\])/, '').split('", "').join(', ') || "Unknown",
        multiple_developers: item.developer.gsub(/(\[\"|\"\])/, '').split('", "').length > 1,
        headerimg: item.headerimg,
        legal: item.legal
      }

      respond_to do |format|
        format.json {render :json => {:results => item_hash}}
      end
    else
      respond_to do |format|
        format.json {render :json => {:results => {}}}
      end
    end
  end

  # POST '/ajax/get_reddit'
  def get_reddit_ajax
    input_name = params[:input_name]

    get_reddit_info(input_name)
    reddit_info = []

    if (@post_names.length != @post_links.length ||
      @post_names.length != @comment_links.length ||
      @post_links.length != @comment_links.length)
      puts "ERROR: Missing reddit info"
    else
      (0..@post_names.length-1).each do |i|
        reddit_info << {name: @post_names[i], link: @post_links[i], comments: @comment_links[i]}
      end
    end

    respond_to do |format|
      format.json {render :json => {:results => reddit_info}}
    end
  end

  # POST '/ajax/get_search_results'
  def get_search_results_ajax
    input_name = params[:input_name]

    google_search_links = google_info(input_name, Time.now)

    respond_to do |format|
      format.json {render :json => {:results => google_search_links}}
    end
  end

  # POST '/ajax/send_suggestion'
  # Precondition: selection parameter is the type of suggestion sent (name of the game, or HLTB, or reddit, etc)
  # Precondition: content parameter is the suggestion message entered by user
  # Precondition: name parameter is the name of the game
  # Postcondition:
  def send_suggestion
    selection = params[:selection]
    content = params[:content]
    name = params[:name]

    s3 = Aws::S3::Client.new
    resp = s3.get_object(bucket:ENV['NEW_GAME_BUCKET'], 
      key:ENV['SUGGESTIONS_FILE'])

    body = resp.body.read
    if body.split(',').size<2000
      body = body + "," + name.gsub(/[^a-zA-Z0-9:()\/\\\-\s]/,'') + ": " + selection.gsub(/[^a-zA-Z0-9:()\/\\\-\s]/,'') + ": " + content.gsub(/[^a-zA-Z0-9:()\/\\\-\s]/,'')
    end

    bucket = Aws::S3::Resource.new(client: s3).bucket(ENV['NEW_GAME_BUCKET'])
    object = bucket.object(ENV['SUGGESTIONS_FILE'])
    object.put(body:body.inspect)

    respond_to do |format|
      format.json {render :nothing => true}
    end
  end

  def set_new_releases
    s3 = Aws::S3::Client.new
    resp = s3.get_object(bucket:ENV['NEW_GAME_BUCKET'], 
      key:ENV['NEW_GAME_FILE'])
    @new_releases = YAML.load(resp.body.read).flatten
  end

  def index
    get_frontpage_deals
    get_more_frontpage_info
    set_new_releases
  end

  # GET '/get_game'
  def get_game
    #Dlc.update(Dlc.find_by(name:"BioShock Infinite: Burial at Sea - Episode Two").id,:itad=>"bioshockinfiniteburialatseaepisodeii")
    #Dlc.update(Dlc.find_by(name:"BioShock Infinite: Burial at Sea - Episode One").id,:itad=>"bioshockinfiniteburialatseaepisodei")
    #Package.update(Package.find_by(name:"Bioshock Infinite + Season Pass Bundle").id,:itad=>"bioshockinfiniteplusseasonpassbundle")

    is_dlc_string = params[:dlc]
    @google_image_links = []

    if is_dlc_string.eql?("true")
      @is_dlc = true
      @game = Game.find_by(id:Dlc.find_by(name:params[:query]).game_id)
    else
      @is_dlc = false
      @game = Game.find_by(name:params[:query])
    end

    # Mostly for js to access easier
    @searched_name = params[:query]

    if !@game
      puts "ERROR: Could not find corresponding game " + params[:query]
    else
      # Populate @associated_names to get all DLCs/packages associated with @game
      add_associated_name(@game.name, false, false)
      Dlc.where(game_id:@game.id).each do |dlc|
        if (!dlc.name.downcase.eql?(@game.name.downcase))
          add_associated_name( dlc.name, true, false)
        end
      end
      Package.where(game_id:@game.id).each do |pkg|
        add_associated_name(pkg.name, false, true)
      end

      # Get misc info and prices for @game only
      get_misc_info_and_prices(@game.name, @game.itad)

      if @prices && @prices[@game.name]
        @lowest_current_arr = @prices[@game.name].sort_by {|entry| entry[:current_price].gsub("$","").to_f}
        @lowest_recorded_arr = @prices[@game.name].sort_by {|entry| entry[:lowest_recorded].gsub("$","").to_f}
      else
        @lowest_current_arr = []
        @lowest_recorded_arr = []
      end

      # Other prices are retrieved one by one with get_prices_ajax
    end
  end
end
