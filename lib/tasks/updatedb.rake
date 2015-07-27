require 'capybara/poltergeist'
task :updatedb => :environment do
  update_database_final
end

def update_steam_game_list()
  return_array = []
  main_url = 'http://store.steampowered.com/search/?sort_by=Released_DESC#sort_by=Name_ASC&category1=998&page='
  
  session = Capybara::Session.new(:poltergeist)
  #local variable we will modify
  url = main_url
  #what page of the search we are on
  page_count = 1
  url+=page_count.to_s
  
  session.visit url
  sleep(1)
  page = Nokogiri::HTML.parse(session.html)
  
  while page_count< 10#ENV['PAGE_COUNT'].to_i
    #!page.at('p:contains("No results were returned for that query.")') && page_count<250
    page.css(".search_result_row").each do |element|
      id = element['href'].slice!(34..41)
      id.gsub!(/[^0-9]/,'')
      title = element.css(".title").text
      if !Game.find_by(steamid:id)
        Game.create(name:title,steamid:id)
        return_array<<id
      end
    end
    url = main_url
    page_count+=1
    url+=page_count.to_s
    
    sleep(0.5)
    session.visit url
    sleep(1)

    page = Nokogiri::HTML.parse(session.html) 
  end
  return return_array
end
def update_steam_dlc(new_games)
    base_url = "http://store.steampowered.com/api/appdetails?appids="
    @failures = []
    @new_dlcs_from_update = []
    new_games.each do |new_game_name|
      game = Game.find_by(steamid:new_game_name)
      id = game.steamid
      #id = 22380
      uri = URI(base_url + id.to_s + "&filter=basic")
      #get the body of the text
      body = page_refresh(uri,5,id,false)

      if valid_json?(body)
        hash = JSON(body)

        #Update game with new values
        Game.update(game.id, get_update_hash(hash,id))
        get_package_info(hash,id,game)

        if has_dlc?(hash,id)
          dlc = hash[id.to_s]["data"]["dlc"]
          if dlc
            dlc.each do |dlc|
              uri = URI(base_url + dlc.to_s + "&filter=basic")
              body = page_refresh(uri,5,dlc,true)
              if valid_json?(body)
                hash = JSON(body)
                if has_name?(hash,dlc)
                  dlc_name = hash[dlc.to_s]["data"]["name"]
                  if !Dlc.find_by(steamid:dlc)
                    dlc_hash = get_update_hash(hash,dlc)
                    dlc_hash[:name] = dlc_name
                    dlc_hash[:steamid] = dlc
                    game.dlcs.create(dlc_hash)
                    @new_dlcs_from_update<<dlc
                  else
                    # if has_metacritic?(hash,dlc)
                    #   meta_score = hash[dlc.to_s]["data"]["metacritic"]["score"]
                    #    meta_url =  hash[dlc.to_s]["data"]["metacritic"]["url"]
                    temp_dlc = Dlc.find_by(steamid:dlc)
                    Dlc.update(temp_dlc.id,get_update_hash(hash,dlc))
                    #end
                  end 
                end
              end
            end
          end
        end
      end
      sleep(0.5)
    end
    return @failures
end
def how_long_to_beat(new_games)
    base_url = "http://howlongtobeat.com/search_main.php?t=games&amp;page=1&amp;sorthead=popular&amp;sortd=Normal%2520Order&amp;plat=&amp;detail=0"
    uri = URI.parse(base_url)
    new_games.each do |new_game_name|
      game = Game.find_by(steamid:new_game_name)
      #response = Net::HTTP.post_form(uri, {"queryString" => game.name})
      response = Net::HTTP.post_form(uri, {"queryString" => 
        clean_string(game.name.to_s)})
      page = Nokogiri::HTML.parse(response.body)
      if page.css(".search_loading").css(".back_white").to_a == []
        first_element = page.css('li')[0]
        html_link = ""
        first_element.css('.text_blue').each do |title|
          html_link = title['href']
        end
        first_element.css('.text_yellow').each do |title|
          html_link = title['href']
        end
        times = first_element.css('.gamelist_tidbit')
        if times && times.size>0
          main_story = 0
          main_extra = 0
          completion = 0
          combined = 0
          for i in (0..times.size-1) do
            if i == 1
              main_story = times[i].text.tr('^0-9', '').to_i
            end 
            if i == 3
              main_extra = times[i].text.tr('^0-9', '').to_i
            end
            if i == 5
              completion = times[i].text.tr('^0-9', '').to_i
            end
            if i ==7 
              combined = times[i].text.tr('^0-9', '').to_i
            end
          end
          Game.update(game.id,:hltb => html_link, 
            :MainStory => main_story, :MainExtra => main_extra, 
            :Completion => completion, :Combined => combined)
        else
          Game.update(game.id,:hltb => html_link)
        end
      end
    end
end
def how_long_to_beat_dlc(new_dlcs)
    base_url = "http://howlongtobeat.com/search_main.php?t=games&amp;page=1&amp;sorthead=popular&amp;sortd=Normal%2520Order&amp;plat=&amp;detail=0"
    uri = URI.parse(base_url)
    new_dlcs.each do |new_dlc_steamid|
      game = Dlc.find_by(steamid:new_dlc_steamid)
      #response = Net::HTTP.post_form(uri, {"queryString" => game.name})
      response = Net::HTTP.post_form(uri, {"queryString" => 
        clean_string(game.name.to_s)})
      page = Nokogiri::HTML.parse(response.body)
      if page.css(".search_loading").css(".back_white").to_a == []
        first_element = page.css('li')[0]
        html_link = ""
        first_element.css('.text_blue').each do |title|
          html_link = title['href']
        end
        first_element.css('.text_yellow').each do |title|
          html_link = title['href']
        end
        times = first_element.css('.gamelist_tidbit')
        if times && times.size>0
          main_story = 0
          main_extra = 0
          completion = 0
          combined = 0
          for i in (0..times.size-1) do
            if i == 1
              main_story = times[i].text.tr('^0-9', '').to_i
            end 
            if i == 3
              main_extra = times[i].text.tr('^0-9', '').to_i
            end
            if i == 5
              completion = times[i].text.tr('^0-9', '').to_i
            end
            if i ==7 
              combined = times[i].text.tr('^0-9', '').to_i
            end
          end
          Dlc.update(game.id,:hltb => html_link, 
            :MainStory => main_story, :MainExtra => main_extra, 
            :Completion => completion, :Combined => combined)
        else
          Dlc.update(game.id,:hltb => html_link)
        end
      end
    end
end
def set_subreddit_for_games(new_games)
    new_games.each do |new_game_name|
      game = Game.find_by(steamid:new_game_name)
      if game.subreddit == nil
        Game.update(game.id,:subreddit => 
          refine_reddit_string(game.name))
      end
    end
end
def update_database_final
    new_games = update_steam_game_list()
    fail = update_steam_dlc(new_games)
    update_steam_dlc_failures(fail)
    how_long_to_beat(new_games)
    how_long_to_beat_dlc(@new_dlcs_from_update)
    set_subreddit_for_games(new_games)
    puts new_games.inspect
    s3 = Aws::S3::Client.new
    bucket = Aws::S3::Resource.new(client: s3).bucket('elasticbeanstalk-us-east-1-528053344435')
    object = bucket.object('database_update')
    object.put(body:new_games.inspect)
end