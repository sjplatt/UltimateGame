require 'open-uri'
require 'watir'
require 'json'

class MainController < ApplicationController
  
  # def update_steam_game_list()
  #   #Base URL For Search
  #   main_url = 'http://store.steampowered.com/search/?sort_by=Released_DESC#sort_by=Name_ASC&category1=998&page='
    
  #   #local variable we will modify
  #   url = main_url
  #   #what page of the search we are on
  #   page_count = 1
  #   url+=page_count.to_s
  #   browser = Watir::Browser.new
  #   browser.goto url
  #   page = Nokogiri::HTML.parse(browser.html)
  #   while !page.at('p:contains("No results were returned for that query.")') && page_count<250
  #     page.css(".search_result_row").each do |element|
  #       id = element['href'].slice!(34..39)
  #       title = element.css(".title").text
  #       if Game.find_by(steamid:id)
  #         puts ""
  #       else 
  #         Game.create(name:title,steamid:id)
  #       end
  #     end
  #     url = main_url
  #     page_count+=1
  #     url+=page_count.to_s
  #     sleep(0.5)
  #     browser.goto url
  #     page = Nokogiri::HTML.parse(browser.html) 
  #   end
  # end
 
  # def page_refresh(uri,max_time,id,is_dlc_id)
  #   time = Time.now+max_time.seconds
  #   resp = Net::HTTP.get_response(uri)
  #   while Time.now<time && resp.body == "null" do 
  #     resp = Net::HTTP.get_response(uri)
  #   end
  #   if resp.body == "null" || resp.class == Net::HTTPBadRequest
  #     @failures<<id if !is_dlc_id
  #     return nil
  #   end
  #   if !valid_json?(resp.body)
  #     return page_refresh(uri,max_time,id,is_dlc_id)
  #   end
  #   return resp.body
  # end

  # def valid_json?(json)
  #   begin
  #     JSON.parse(json)
  #     return true
  #   rescue Exception => e
  #     return false
  #   end
  # end
  
  # def get_update_hash(hash,id)
  #   game_update_hash = Hash.new
  #   if has_metacritic?(hash,id)
  #     game_update_hash[:metascore] = get_metacritic_score(hash,id)
  #     game_update_hash[:metaurl] = get_metacritic_url(hash,id)
  #   end
  #   if has_description?(hash,id)
  #     game_update_hash[:description] = get_description(hash,id)
  #   end
  #   if has_reviews?(hash,id)
  #     game_update_hash[:review] = get_reviews(hash,id)
  #   end
  #   if has_website?(hash,id)
  #     game_update_hash[:website] = get_website(hash,id)
  #   end
  #   if has_min_req?(hash,id)
  #     game_update_hash[:minreq] = get_min_req(hash,id)
  #   end
  #   if has_rec_req?(hash,id)
  #     game_update_hash[:recreq] = get_rec_req(hash,id)
  #   end
  #   if has_legal_notice?(hash,id)
  #     game_update_hash[:legal] = get_legal_notice(hash,id)
  #   end
  #   if has_release_date?(hash,id)
  #     game_update_hash[:releasedate] = get_release_date(hash,id)
  #   end
  #   if has_developer?(hash,id)
  #     game_update_hash[:developer] = get_developer(hash,id)
  #   end
  #   if has_header_image?(hash,id)
  #     game_update_hash[:headerimg] = get_header_image(hash,id)
  #   end
  #   if has_recommendation?(hash,id)
  #     game_update_hash[:recommendations] = get_recommendation(hash,id)
  #   end
  #   return game_update_hash
  # end

  # def update_steam_dlc()
  #   base_url = "http://store.steampowered.com/api/appdetails?appids="
  #   @failures = []
  #   Game.all.each do |game|
  #     id = game.steamid
  #     #id = 22380
  #     uri = URI(base_url + id.to_s + "&filter=basic")
  #     #get the body of the text
  #     body = page_refresh(uri,5,id,false)

  #     if valid_json?(body)
  #       hash = JSON(body)

  #       #Update game with new values
  #       Game.update(game.id, get_update_hash(hash,id))
  #       get_package_info(hash,id,game)

  #       if has_dlc?(hash,id)
  #         dlc = hash[id.to_s]["data"]["dlc"]
  #         if dlc
  #           dlc.each do |dlc|
  #             uri = URI(base_url + dlc.to_s + "&filter=basic")
  #             body = page_refresh(uri,5,dlc,true)
  #             if valid_json?(body)
  #               hash = JSON(body)
  #               if has_name?(hash,dlc)
  #                 dlc_name = hash[dlc.to_s]["data"]["name"]
  #                 if !Dlc.find_by(steamid:dlc)
  #                   dlc_hash = get_update_hash(hash,dlc)
  #                   dlc_hash[:name] = dlc_name
  #                   dlc_hash[:steamid] = dlc
  #                   game.dlcs.create(dlc_hash)
  #                 else
  #                   # if has_metacritic?(hash,dlc)
  #                   #   meta_score = hash[dlc.to_s]["data"]["metacritic"]["score"]
  #                   #    meta_url =  hash[dlc.to_s]["data"]["metacritic"]["url"]
  #                   temp_dlc = Dlc.find_by(steamid:dlc)
  #                   Dlc.update(temp_dlc.id,get_update_hash(hash,dlc))
  #                   #end
  #                 end 
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end
  #     sleep(0.5)
  #   end
  #   return @failures
  # end
  
  # def get_package_info(hash,id,game)
  #   base_url = "http://store.steampowered.com/api/packagedetails?packageids="
    
  #   if has_packages?(hash,id)
  #     packages = get_packages(hash,id)

  #     packages.each do |package|
  #       uri = URI(base_url + package.to_s)
  #       body = page_refresh(uri,5,id,false)
  #       game_update_hash = Hash.new
        
  #       if valid_json?(body)
  #         hash = JSON(body)
  #         if has_name?(hash,package.to_i)

  #           game_update_hash[:name] = get_name(hash,package.to_i)
  #           game_update_hash[:packageid] = package
  #           if has_small_logo?(hash,package.to_i)
  #             game_update_hash[:headerimg] = get_small_logo(hash,package.to_i)
  #           end
  #           if has_release_date?(hash,package.to_i)
  #             game_update_hash[:releasedate] = get_release_date(hash,
  #               package.to_i)
  #           end
  #           if has_apps?(hash,package.to_i)
  #             app_id_insert = ""
  #             get_apps(hash,package.to_i).each do |app|
  #               if app && app["id"]
  #                 app_id_insert+=app["id"].to_s + ","
  #               end
  #             end
  #             app_id_insert = app_id_insert.chop
  #             game_update_hash[:apps] = app_id_insert
  #           end
  #           puts game_update_hash.inspect
  #           if game.packages.find_by(packageid:package)
  #             temp_package = game.packages.find_by(packageid:package)
  #             game.packages.update(temp_package.id,game_update_hash)
  #           else
  #             game.packages.create(game_update_hash)
  #           end
  #         end
  #       end
  #     end

  #   end
  # end

  # def update_steam_dlc_failures(numbers)
  #   base_url = "http://store.steampowered.com/api/appdetails?appids="
  #   @failures = []
  #   numbers.each do |num|
  #     game = Game.find_by(steamid:num)
  #     id = game.steamid
  #     #id = 22380
  #     uri = URI(base_url + id.to_s + "&filter=basic")
  #     #get the body of the text
  #     body = page_refresh(uri,5,id,false)

  #     if valid_json?(body)
  #       hash = JSON(body)
        
  #       Game.update(game.id, get_update_hash(hash,id))
        

  #       if has_dlc?(hash,id)
  #         dlc = hash[id.to_s]["data"]["dlc"]
  #         if dlc
  #           dlc.each do |dlc|
  #             uri = URI(base_url + dlc.to_s + "&filter=basic")
  #             body = page_refresh(uri,5,dlc,true)
  #             if valid_json?(body)
  #               hash = JSON(body)
  #               if has_name?(hash,dlc)
  #                 dlc_name = hash[dlc.to_s]["data"]["name"]
  #                 if !Dlc.find_by(steamid:dlc)
  #                   dlc_hash = get_update_hash(hash,dlc)
  #                   dlc_hash[:name] = dlc_name
  #                   dlc_hash[:steamid] = dlc
  #                   game.dlcs.create(dlc_hash)
  #                 else
  #                   # if has_metacritic?(hash,dlc)
  #                   #   meta_score = hash[dlc.to_s]["data"]["metacritic"]["score"]
  #                   #    meta_url =  hash[dlc.to_s]["data"]["metacritic"]["url"]
  #                   #   temp_dlc = Dlc.find_by(steamid:dlc)
  #                   #   Dlc.update(temp_dlc.id, 
  #                   #     :name => temp_dlc.name, :steamid => dlc,
  #                   #     :metascore => meta_score, :metaurl => meta_url)
  #                   # end
  #                   temp_dlc = Dlc.find_by(steamid:dlc)
  #                   Dlc.update(temp_dlc.id,get_update_hash(hash,dlc))
  #                 end 
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end
  #     sleep(0.5)
  #   end
  # end
  
  # def clean_string(str)
  #   cleaned = ""
  #   str.each_byte { |x|  cleaned << x unless x > 127   }
  #   cleaned.tr!(':&-','')
  #   cleaned.gsub!(/\s+/, ' ')
  #   return cleaned
  # end

  # def how_long_to_beat()
  #   base_url = "http://howlongtobeat.com/search_main.php?t=games&amp;page=1&amp;sorthead=popular&amp;sortd=Normal%2520Order&amp;plat=&amp;detail=0"
  #   uri = URI.parse(base_url)
  #   Game.all.each do |game|
  #     #response = Net::HTTP.post_form(uri, {"queryString" => game.name})
  #     response = Net::HTTP.post_form(uri, {"queryString" => 
  #       clean_string(game.name.to_s)})
  #     page = Nokogiri::HTML.parse(response.body)
  #     if page.css(".search_loading").css(".back_white").to_a == []
  #       first_element = page.css('li')[0]
  #       html_link = ""
  #       first_element.css('.text_blue').each do |title|
  #         html_link = title['href']
  #       end
  #       times = first_element.css('.gamelist_tidbit')
  #       if times && times.size>0
  #         main_story = 0
  #         main_extra = 0
  #         completion = 0
  #         combined = 0
  #         for i in (0..times.size-1) do
  #           if i == 1
  #             main_story = times[i].text.tr('^0-9', '').to_i
  #           end 
  #           if i == 3
  #             main_extra = times[i].text.tr('^0-9', '').to_i
  #           end
  #           if i == 5
  #             completion = times[i].text.tr('^0-9', '').to_i
  #           end
  #           if i ==7 
  #             combined = times[i].text.tr('^0-9', '').to_i
  #           end
  #         end
  #         Game.update(game.id,:hltb => html_link, 
  #           :MainStory => main_story, :MainExtra => main_extra, 
  #           :Completion => completion, :Combined => combined)
  #       end
  #     end
  #   end
  # end

  # def how_long_to_beat_dlc()
  #   base_url = "http://howlongtobeat.com/search_main.php?t=games&amp;page=1&amp;sorthead=popular&amp;sortd=Normal%2520Order&amp;plat=&amp;detail=0"
  #   uri = URI.parse(base_url)
  #   Dlc.all.each do |game|
  #     #response = Net::HTTP.post_form(uri, {"queryString" => game.name})
  #     response = Net::HTTP.post_form(uri, {"queryString" => 
  #       clean_string(game.name.to_s)})
  #     page = Nokogiri::HTML.parse(response.body)
  #     if page.css(".search_loading").css(".back_white").to_a == []
  #       first_element = page.css('li')[0]
  #       html_link = ""
  #       first_element.css('.text_blue').each do |title|
  #         html_link = title['href']
  #       end
  #       times = first_element.css('.gamelist_tidbit')
  #       if times && times.size>0
  #         main_story = 0
  #         main_extra = 0
  #         completion = 0
  #         combined = 0
  #         for i in (0..times.size-1) do
  #           if i == 1
  #             main_story = times[i].text.tr('^0-9', '').to_i
  #           end 
  #           if i == 3
  #             main_extra = times[i].text.tr('^0-9', '').to_i
  #           end
  #           if i == 5
  #             completion = times[i].text.tr('^0-9', '').to_i
  #           end
  #           if i ==7 
  #             combined = times[i].text.tr('^0-9', '').to_i
  #           end
  #         end
  #         Dlc.update(game.id,:hltb => html_link, 
  #           :MainStory => main_story, :MainExtra => main_extra, 
  #           :Completion => completion, :Combined => combined)
  #       end
  #     end
  #   end
  # end

  #Precondition: str is a string
  #PostCondition: returns a string that is a simplified
  #version of str for searching subreddit
  #NOTE: WILL NEED TO BE REFINED
  def refine_reddit_string(str)
    str = str.to_s
    cleaned = ""
    str.each_char do |x|
      if x.ord >127 && x.ord != 8217
        break
      else cleaned << x
      end
    end
    cleaned.gsub!(/\s+/, ' ')
    if cleaned
      cleaned = cleaned.split(':')[0]
      if cleaned
        cleaned = cleaned.split("-")[0]
        if cleaned
          cleaned = cleaned.split("&")[0]
          if cleaned
            cleaned = cleaned.split("(")[0]
              if cleaned
                cleaned.delete!('\'')
                if cleaned
                  cleaned.gsub!(/\s+/, '')
               end
             end
          end
        end
      end
    end
    if cleaned
     cleaned.delete!('^a-zA-Z')
    end
    return cleaned
  end

  def get_reddit_info(name)
    base_url = "http://www.reddit.com/r/"
    base_url+= refine_reddit_string(name)

    page = Nokogiri::HTML.parse(open(base_url))
    #puts page
  end

  def index
    #DO NOT CALL ANY OF THESE AT RUNTIME
    #####
    #update_steam_game_list
    #fail = update_steam_dlc
    #update_steam_dlc_failures(fail)
    #how_long_to_beat
    #how_long_to_beat_dlc
    #####
    get_reddit_info("Witcher 3: wild hunt")
  end
end