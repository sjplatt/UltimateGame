require 'fuzzystringmatch'
require 'google/api_client'
require 'trollop'

class MainController < ApplicationController
  
  #Precondition: id is a id of a game. ID MUST BE VALID
  #PostCondition: creates instance variable @post_links for the links of
  #the reddit posts and @post_names for the titles, @comment_links
  #for the link to the comments
  def get_reddit_info(id)
    @post_names = []
    @post_links = []
    @comment_links = []
    base_url = "http://www.reddit.com/r/"
    game = Game.find_by(id:id)
    base_url+= game.subreddit + "/top?sort=top&t=month"

    page = Nokogiri::HTML.parse(open(base_url))
    if page.css('#noresults') && page.css('#noresults') == []
      return
    else
      table = page.css('#siteTable')
      table.css('.thing').each do |post|
        link = ""
        comment = ""
        title = ""
        post.css('a.title').each do |title_html|
          title = title_html.text
          link = title_html['href']
        end
        post.css('.comments').each do |comment_link|
          comment = comment_link['href']
        end
        if link[0..2] == "/r/"
          link = comment
        end
        if link != "" && comment != "" && title != ""
          @post_names << title
          @post_links << link
          @comment_links << comment
        end
      end
    end
  end

  #Precondition: name is the name of a game.
  #Postcondition: creates instance variable @google_links for the
  #top 10 links for the google search of name "reviews"
  def google_info(name)
    @google_links = []
    count = 0
    Google::Search::Web.new(:query => (name + "reviews")).each do |web|
      if !web.uri.include?("reddit") && !web.uri.include?("wikipedia") && 
        !web.uri.include?("youtube") && count<10
        @google_links << web.uri
        count+=1
      end
    end
  end

  #Precondition: name is the name of a game.
  #Postcondition: creates instance variable @google_image_links for
  #the links for the images of the game
  def google_image_info(name)
    @google_image_links = []
    Google::Search::Image.new(:query => (name+"imgur")).each do |image|
      if image.uri.include?("imgur")
        @google_image_links<< image.uri
      end
    end
  end

  DEVELOPER_KEY = ENV['YOUTUBE_API_KEY']
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def get_service
    client = Google::APIClient.new(
      :key => DEVELOPER_KEY,
      :authorization => nil,
      :application_name => "Game Comparison",
      :application_version => '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    return client, youtube
  end
  
  #Precondition: name is the name of a game
  #Precondition: tag = "reviews" or tag = "gameplay"
  #Postcondition: RETURN three arrays in this order
  #First array is set of youtube video names
  #Second array is set of youtube video links
  #Third array is set of image links for the videos
  def youtube_info(name,tag)
    search_term = name + tag
    video_names = []
    video_links = []
    video_image_links = []
    opts = Trollop::options do
      opt :q, search_term, :type => String, :default => search_term
      opt :max_results, 'Max results', :type => :int, :default => 10
    end

    client, youtube = get_service

    begin
      # Call the search.list method to retrieve results matching the specified
      # query term.
      search_response = client.execute!(
        :api_method => youtube.search.list,
        :parameters => {
          :part => 'snippet',
          :q => opts[:q],
          :maxResults => opts[:max_results],
          :orderby => "viewCount"
        }
      )

      # Add each result to the appropriate list, and then display the lists of
      # matching videos, channels, and playlists.
      search_response.data.items.each do |search_result|
        case search_result.id.kind
          when 'youtube#video'
            video_names << "#{search_result.snippet.title}"
            video_links << "https://www.youtube.com/watch?v="+
            "#{search_result.id.videoId}"
            video_image_links << 
            "#{search_result.snippet.thumbnails.default.url}"
        end
      end

    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
    return video_names,video_links,video_image_links
  end

  #Precondition: MUST CALL get_frontpage_deals first
  #Postcondition: Merges with @large_capsules. Creates @new_releases
  #and removes duplicates from get_frontpage_deals
  def get_more_frontpage_info()
    specials = []
    top_sellers = []
    @new_releases = []
    base_url = "http://store.steampowered.com/api/featuredcategories/"
    uri = URI(base_url)
    #get the body of the text
    body = page_refresh_no_id(uri,1)
    if valid_json?(body)
      hash = JSON(body)
      if has_top_sellers?(hash)
        top_seller = get_top_sellers(hash)
        top_seller.each do |cap|
          if has_id?(cap)
            top_sellers << get_id(cap)
          end
        end
      end
      if has_specials?(hash)
        special = get_specials(hash)
        special.each do |cap|
          if has_id?(cap)
            specials << get_id(cap)
          end
        end
      end
      if has_new_releases?(hash)
        release = get_new_releases(hash)
        release.each do |cap|
          if has_id?(cap)
            @new_releases << get_id(cap)
          end
        end
      end
    else
      puts "ERROR: PLEASE RELOAD WEBSITE"
    end
    @large_capsules = 
    (@large_capsules | specials | top_sellers).uniq
    #remove_duplicate_frontpage_info
  end

  #Postcondition: creates instance variable @large_capsules which contains
  #the ids of the apps for the large banner
  def get_frontpage_deals()
    @large_capsules = []
    base_url = "http://store.steampowered.com/api/featured/"
    uri = URI(base_url)
    #get the body of the text
    body = page_refresh_no_id(uri,1)
    if valid_json?(body)
      hash = JSON(body)
      if has_large_capsules?(hash)
        large_cap = get_large_capsules(hash)
        large_cap.each do |cap|
          if has_id?(cap)
            @large_capsules << get_id(cap)
          end
        end
      end
    else
      puts "ERROR: PLEASE RELOAD WEBSITE"
    end
  end

  #Precondition: name is the search term
  #Postcondition: @top_ids is a list of STEAMIDS in order of 
  #closest match
  def fuzzy_string_analysis_initial(name)
    name = clean_string_stronger(name)
    puts name
    @top_ids = []
    top_scores = []
    jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
    Game.all.each do |game|
      if clean_string_stronger(game.name.downcase).include?(name.downcase)
        @top_ids << game.steamid
        top_scores<<jarow.getDistance(name,game.name)+0.5
      end
    end
    Dlc.all.each do |dlc|
      if clean_string_stronger(dlc.name.downcase).include?(name.downcase)
        @top_ids << dlc.steamid
        top_scores<<jarow.getDistance(name,dlc.name)
      end
    end
    top_scores,@top_ids = top_scores.zip(@top_ids).sort_by(&:last).transpose
  end

  #NOTES:s
  #ORDER TO UPDATE DATABASE
  #1) update_steam_game_list() to get new games. WILL OPEN BROWSER
  #2) fail = update_steam_dlc()
  #3) update_steam_dlc_failures(fail) will try to fix failures
  #4) how_long_to_beat()
  #5) how_long_to_beat_dlc()
  #6) set_subreddit_for_games
  def update_db()
    #update_steam_game_list
    fail = update_steam_dlc
    update_steam_dlc_failures(fail)
    how_long_to_beat
    how_long_to_beat_dlc
    set_subreddit_for_games
  end

  #def index
    #get_reddit_info(292030)
    #google_info("Witcher 3")
    #google_image_info("Witcher 3: Wild Hunt")
    #get_frontpage_deals
    #fuzzy_string_analysis_initial("fallout new vegas")
    #puts @top_ids
  #end
  def get_timestamp()
    base_url = "http://isthereanydeal.com/#/page:game/info?plain=bogus"
    page = Nokogiri::HTML.parse(open(base_url))
    page.css('script').each do |script|
      if script.text.include?("lazy.params.file")
        split = script.text.split("lazy.params.file")
        if split.size>1
          data = split[1]
          semi_split = data.split(";")
          if semi_split.size>1
            return semi_split[0].gsub(/[\s\"=]/,"")
            break
          end
        end
      end
    end
  end

  def encode_itad_plain(name)
    # Rules:
    # Every "+" becomes "plus"
    # Every "&" becomes "and"
    # Every "the" becomes "" (whole word only; '"the' stays the same)
    # All digits except 0 get converted to lowercase Roman numerals
    # All other non-alphanumeric characters are removed
    # (This means e.g. 12 and 3 both get converted to "iii"
    #  but this shouldn't be a problem if it isn't for ITAD)
    spaced_plain = name.gsub(/\+/,"plus")
                       .gsub(/&/,"and")
                       .gsub(/\bthe\b/i,"")
                       .gsub(/1/,"i")
                       .gsub(/2/,"ii")
                       .gsub(/3/,"iii")
                       .gsub(/4/,"iv")
                       .gsub(/5/,"v")
                       .gsub(/6/,"vi")
                       .gsub(/7/,"vii")
                       .gsub(/8/,"viii")
                       .gsub(/9/,"ix");
    return clean_string_stronger(spaced_plain).gsub(/\s/,"").downcase;
  end

  #Precondition: associated_with is the game the item is associated with
  #Precondition: input_name is the name of the item
  #Precondition: itad_plain is the part after plain= in corresponding ITAD URL
  #Precondition: input_is_DLC is true if game is dlc
  #Precondition: input_is_pkg is true if game is a package
  #Postcondition: @prices_info is created if it doesn't exist
  #Postcondition: It is populated with name,is_dlc,is_pkg,metascore,
  #Postcondition: metacritic_link,steam_percentage,wiki_link,prices
  def get_price_information(associated_with,input_name,itad_plain,input_is_DLC,input_is_pkg)
    # default outputs
    metascore = "??"
    metacritic_link = "http://metacritic.com"
    steam_percentage = "??"
    wiki_search_string = URI.encode(input_name)
    wiki_link = "http://en.wikipedia.org/w/index.php?title=Special%3ASearch&search=#{wiki_search_string}&button="
    prices = []

    if !input_name
      puts "[CRITICAL] Could not find the input_name (must be exact!)"
    else
      #puts input_name
      detailed_deals_url = "http://isthereanydeal.com/ajax/game/info?plain=#{itad_plain}"
      puts detailed_deals_url
      begin
        detailed_deals = Nokogiri::HTML(open(detailed_deals_url))
      rescue Exception => e
        puts "Nokogiri HTML error: #{e}"
      end

      #puts detailed_deals.text
      if detailed_deals.nil?
        puts "[CRITICAL] Nokogiri HTML call for detailed deals failed"
        puts "[Note] Consider using link only, since scraping details won't work"
      else
        # ENSURES: All calls to the detailed page for itad_plain contain data
        if detailed_deals.at("span.score.score-number")
          metascore = detailed_deals.at("span.score.score-number").text.to_i
        end

        if detailed_deals.at("div.score-section a")
          if detailed_deals.at("div.score-section a")[:href]
            metacritic_link = detailed_deals.at("div.score-section a")[:href]
          end
        end
        
        if detailed_deals.css("div.score-section") && detailed_deals.css("div.score-section") != [] && detailed_deals.css("div.score-section")[1]
          if detailed_deals.css("div.score-section")[1].css("span") && detailed_deals.css("div.score-section")[1].css("span") != []
            if detailed_deals.css("div.score-section")[1].css("span")[2]
              steam_text = detailed_deals.css("div.score-section")[1].css("span")[2].text
              start_index2 = steam_text.index(", ") + ", ".length()
              end_index2 = steam_text.index("%")
              steam_percentage = steam_text[start_index2..end_index2].to_i
            end
          end
        end
        
        if detailed_deals.at("div.wiki.link a")
          if detailed_deals.at("div.wiki.link a")[:href]
            wiki_link = detailed_deals.at("div.wiki.link a")[:href]
          end
        end

        if detailed_deals.at("div.buy table")
          price_table = detailed_deals.at("div.buy table")
          price_rows = price_table.css("tr.row")
          price_rows.each do |row|
            store = row.css("td")[0].at("a").text
            store_url = row.css("td")[0].at("a")[:href]
            price_cut = row.at("td.cut").text
            current_price = row.at("td.new").text
            lowest_recorded = row.at("td.low").text
            regular_price = row.at("td.old").text
            prices.push({store: store,
                         store_url: store_url,
                         price_cut: price_cut,
                         current_price: current_price,
                         lowest_recorded: lowest_recorded,
                         regular_price: regular_price})
          end
        end
      end
    end

    if !@price_info
      @price_info = {}
    end
    @price_info[input_name] = {default: input_name.eql?(associated_with),
                              is_dlc: input_is_DLC,
                              is_pkg: input_is_pkg,
                              metascore: metascore,
                              metacritic_link: metacritic_link,
                              steam_percentage: steam_percentage,
                              wiki_link: wiki_link,
                              prices: prices}
    # is_dlc,is_pkg can be:
    # false,false (just the game itself),
    # (sometimes it is listed as a package, so default specifies it as
    #  "the game itself" if this is the case)
    # true,false,
    # false,true
  end

  def is_itad_url_valid(game_name)
    formatted_game_name = encode_itad_plain(game_name)
    detailed_deals_url = "http://isthereanydeal.com/ajax/game/info?plain=#{formatted_game_name}"
    begin
      detailed_deals = Nokogiri::HTML(open(detailed_deals_url))
    rescue Exception => e
      puts "Nokogiri HTML error: #{e}"
      return false
    end

    if detailed_deals.at("div.pageError div.pageMessageContent")
      if detailed_deals.at("div.pageError div.pageMessageContent").text.eql?("We don't have this game in our database")
        return false
      end
    end

    if detailed_deals.at("div#pageContent .section")
      return true
    end

    return false
  end

  def index
    get_frontpage_deals
    get_more_frontpage_info
  end

  def get_game
    is_dlc_string = params[:dlc]

    if is_dlc_string.eql?("true")
      @is_dlc = true
      @game = Dlc.find_by(name:params[:query])
      if !@game
        puts "ERROR: Could not find " + params[:query]
      else
        get_price_information(@game.name, true, false)
      end
    else
      @is_dlc = false
      @game = Game.find_by(name:params[:query])
      if !@game
        puts "ERROR: Could not find " + params[:query]
      else
        get_price_information(@game.name, @game.name, @game.itad, false, false)
        Dlc.where(game_id:@game.id).each do |dlc|
          get_price_information(@game.name, dlc.name, dlc.itad, true, false)
        end
        Package.where(game_id:@game.id).each do |pkg|
          get_price_information(@game.name, pkg.name, pkg.itad, false, true)
        end
      end
      puts @price_info
    end

    # @top_ids = Game.search(params[:query]).map(&:steamid)
    # fuzzy_string_analysis_initial(params[:query])

    # input = params[:search_term][:steamid].downcase
    # fuzzy_string_analysis_initial(input)

    # if @top_ids && @top_ids != []
    #   @game = Game.find_by(steamid:@top_ids[0])
    # end
  end
end