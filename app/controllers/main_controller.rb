require 'fuzzystringmatch'

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

  #Precondition: name is the name of a game
  #Precondition: tag = "reviews" or tag = "gameplay"
  #Postcondition: IN PROGRESS
  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  def youtube_info(name,tag)
    
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

  #Precondition: game_name is the name of the game
  #Precondition: input_is_DLC is true if game is dlc
  #Postcondition: @metascore,@metacritic_link,@steam_percentage,
  #Postcondition: @wiki_link,@prices are created
  def get_price_information(game_name,input_is_DLC)
    # default outputs
    @metascore = "Unknown"
    @metacritic_link = "Unknown"
    @steam_percentage = "Unknown"
    @wiki_link = "Unknown"
    @prices = []

    raw_game_name = strip_nonalphanumeric(game_name)
    filterArg = URI.encode("/search:#{raw_game_name};/scroll:#gamelist;")
    now = get_timestamp
    now_prime = get_timestamp.split('.')[1]
    region = "us"
    offset = 0

    finalNondealsURL = "http://www.isthereanydeal.com"\
    "/ajax/nondeal.php?by=time%3Adesc&offset=0&limit=75"\
    "&filter=#{filterArg}"\
    "&file=#{now}&lastSeen=#{now_prime}&region=#{region}"

    finalDealsURL =
    "http://www.isthereanydeal.com"\
    "/ajax/data/lazy.deals.php?by=time%3Adesc&offset=#{offset}&limit=75"\
    "&filter=#{filterArg}"\
    "&file=#{now}&lastSeen=#{now_prime}&region=#{region}"

    begin
      nondeals = Nokogiri::HTML(open(finalNondealsURL))
      deals = Nokogiri::HTML(open(finalDealsURL))
    rescue Exception => e
      puts "Nokogiri HTML error: #{e}"
    end
    if nondeals.nil? || deals.nil?
      puts "[CRITICAL] One or more Nokogiri calls failed"
    else

      # ENSURES: All calls to the deals/nondeals pages are valid HTML
      deals_hashlist = []
      nondeals_hashlist = []
      combined_hashlist = []



      # Creating the deals hash list
      reformatted_deals = Nokogiri::HTML(deals.to_s.gsub("\/","/"))

      if reformatted_deals.text.downcase.include?("timeout")
        puts "[WARNING] The timestamp used to generate the deals page is bad"
      elsif reformatted_deals.text.include?('"list":""')
        puts "[WARNING] No deal games found. No results on sale or bad query"
      else
        # ENSURES: All calls to the deals page contain games
        deals_list = reformatted_deals.css("a.noticeable")
        while deals_list.length() > 0
          puts "[Note] Pulling #{deals_list.length()} deals..."
          deals_list.each do |list_item|
            this_game_string = get_game_string(list_item[:href])

            end_index = list_item.text.index(" share") - 1
            name = list_item.text[0..end_index]
            sanitized_name = clean_string_stronger(name)
            url = URI.decode(list_item[:href]).gsub("\\","")
            isDLC = !list_item.at_css("a.dlc").nil? && list_item.css("a.dlc")[0][:href].include?(this_game_string)
            
            deals_hashlist.push({name: name, sanitized_name: sanitized_name, url: url, isDLC: isDLC})
            combined_hashlist.push({name: name, sanitized_name: sanitized_name, url: url, isDLC: isDLC})
          end

          # keep looping until we get all the games, if more exist
          offset += deals_list.length()
          finalDealsURL2 =
          "http://isthereanydeal.com"\
          "/ajax/data/lazy.deals.php?by=time%3Adesc&offset=#{offset}&limit=75"\
          "&filter=#{filterArg}"\
          "&file=#{now}&lastSeen=#{now_prime}&region=#{region}"
          # hopefully this doesn't break, only thing changed is offset
          deals2 = Nokogiri::HTML(open(finalDealsURL2))
          reformatted_deals2 = Nokogiri::HTML(deals2.to_s.gsub("\/","/"))
          deals_list = reformatted_deals2.css("a.noticeable")
        end
      end



      # Creating the non-deals hash list
      if nondeals.at_css("p.refNote")
        puts "[WARNING] No nondeal games found. All results on sale or bad query"
      else
        # ENSURES: All calls to the nondeals page contain games
        nondeals_list = nondeals.css("div.game")
        nondeals_list.each do |list_item|
          name = list_item.at("a.noticeable").text
          sanitized_name = clean_string_stronger(name)
          url = list_item.at("a.noticeable")[:href]
          isDLC = !list_item.at_css("a.dlc").nil?

          nondeals_hashlist.push({name: name, sanitized_name: sanitized_name, url: url, isDLC: isDLC})
          combined_hashlist.push({name: name, sanitized_name: sanitized_name, url: url, isDLC: isDLC})
        end
      end



      # Splitting each hash list into deals on DLCs and nondeals on DLCs

      #puts "Deals hash @@@@@@@@@@@@@@@@@@@@@@"
      #puts deals_hashlist
      #puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      #puts "Nondeals hash @@@@@@@@@@@@@@@@@@@"
      #puts nondeals_hashlist
      #puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

      deals_hashlist_DLC = []
      nondeals_hashlist_DLC = []
      combined_hashlist_DLC = []

      # Note: some of these may be empty
      deals_hashlist.each do |item|
        if item[:isDLC]
          deals_hashlist_DLC.push(item)
          deals_hashlist.delete(item)
        end
      end
      nondeals_hashlist.each do |item|
        if item[:isDLC]
          nondeals_hashlist_DLC.push(item)
          nondeals_hashlist.delete(item)
        end
      end
      combined_hashlist.each do |item|
        if item[:isDLC]
          combined_hashlist_DLC.push(item)
          combined_hashlist.delete(item)
        end
      end



      # Fuzzy string matching to search the proper list for the input

      if input_is_DLC
        deals_matcher = FuzzyMatch.new(deals_hashlist_DLC, :read => :sanitized_name)
        nondeals_matcher = FuzzyMatch.new(nondeals_hashlist_DLC, :read => :sanitized_name)
        combined_matcher = FuzzyMatch.new(combined_hashlist_DLC, :read => :sanitized_name)
      else
        deals_matcher = FuzzyMatch.new(deals_hashlist, :read => :sanitized_name)
        nondeals_matcher = FuzzyMatch.new(nondeals_hashlist, :read => :sanitized_name)
        combined_matcher = FuzzyMatch.new(combined_hashlist, :read => :sanitized_name)
      end

      found_deal = deals_matcher.find(clean_string_stronger(game_name))
      found_nondeal = nondeals_matcher.find(clean_string_stronger(game_name))
      found_combined = combined_matcher.find(clean_string_stronger(game_name))

      if found_deal && found_nondeal &&
        found_deal[:sanitized_name].eql?(found_nondeal[:sanitized_name])
        # use the one in the deals list, idk why the nondeals list sometimes
        # shows things that should be in the deals list
        game_needed = found_deal
      else
        if found_combined
          game_needed = found_combined
        else
          puts "[WARNING] No game was matched. Are all lists empty? Did you correctly specify DLCness?"
        end
      end


      # Scraping the detail page (the popup when clicking on a link)
      
      if !game_needed
        puts "[CRITICAL] See above; could not find the game_needed"
      else
        #puts game_needed
        formatted_game_name = get_game_string(game_needed[:url])
        begin
          detailed_deals = Nokogiri::HTML(open("http://isthereanydeal.com/ajax/game/info?plain=#{formatted_game_name}"))
        rescue Exception => e
          puts "Nokogiri HTML error: #{e}"
        end

        #puts detailed_deals.text
        if detailed_deals.nil?
          puts "[CRITICAL] Nokogiri HTML call for detailed deals failed"
          puts "[Note] Consider using link only, since scraping details won't work"
        else
          # ENSURES: All calls to the detailed page for formatted_game_name contain data
          if detailed_deals.at("span.score.score-number")
            @metascore = detailed_deals.at("span.score.score-number").text.to_i
          end

          if detailed_deals.at("div.score-section a")
            if detailed_deals.at("div.score-section a")[:href]
              @metacritic_link = detailed_deals.at("div.score-section a")[:href]
            end
          end
          
          if detailed_deals.css("div.score-section")
            if detailed_deals.css("div.score-section")[1].css("span")
              if detailed_deals.css("div.score-section")[1].css("span")[2]
                steam_text = detailed_deals.css("div.score-section")[1].css("span")[2].text
                start_index2 = steam_text.index(", ") + ", ".length()
                end_index2 = steam_text.index("%")
                @steam_percentage = steam_text[start_index2..end_index2].to_i
              end
            end
          end
          
          if detailed_deals.at("div.wiki.link a")
            if detailed_deals.at("div.wiki.link a")[:href]
              @wiki_link = detailed_deals.at("div.wiki.link a")[:href]
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
              @prices.push({store: store,
                            store_url: store_url,
                            price_cut: price_cut,
                            current_price: current_price,
                            lowest_recorded: lowest_recorded,
                            regular_price: regular_price})
            end
          end
        end
      end
    end

    #puts @metascore
    #puts @metacritic_link 
    #puts @steam_percentage
    #puts @wiki_link
    #puts @prices
  end

  def index
    #get_price_information("Bioshock Infinite",false)
    get_frontpage_deals
    get_more_frontpage_info
  end

  def get_game
    is_dlc_string = params[:dlc]

    if is_dlc_string.eql?("true")
      @is_dlc = true
      @game = Dlc.find_by(name:params[:query])
    else
      @is_dlc = false
      @game = Game.find_by(name:params[:query])
    end

    if !@game
      puts "ERROR: Could not find " + params[:query]
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