module PriceInfo

  #Precondition: input_name is the name of the game/DLC/package we are currently viewing
  #Precondition: itad_plain is the part after plain= in corresponding ITAD URL
  #Postcondition: @misc_info hash is created if it doesn't exist
  #Postcondition: It is populated with metascore, metacritic_link, steam_percentage, wiki_link
  def get_misc_info_and_prices(input_name, itad_plain)
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
      detailed_deals_url = "https://isthereanydeal.com/ajax/game/info?plain=#{itad_plain}"
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

        # Metascore
        if detailed_deals.at("span.score.score-number")
          metascore = detailed_deals.at("span.score.score-number").text.to_i
        end

        # Metacritic link
        if detailed_deals.at("div.score-section a")
          if detailed_deals.at("div.score-section a")[:href]
            metacritic_link = detailed_deals.at("div.score-section a")[:href]
          end
        end
        
        # Steam percentage
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
        
        # Wiki link
        if detailed_deals.at("div.wiki.link a")
          if detailed_deals.at("div.wiki.link a")[:href]
            wiki_link = detailed_deals.at("div.wiki.link a")[:href]
          end
        end

        # Prices
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

        if !@prices
          @prices = {}
        end
        @prices[input_name] = prices
        # e.g. @prices = {"Bioshock Infinite"=>[{price entry 1}, {price entry 2}, ...], ...}

      end
    end

    @misc_info = {metascore: metascore,
                  metacritic_link: metacritic_link,
                  steam_percentage: steam_percentage,
                  wiki_link: wiki_link}
  end

  # Precondition: input_name is the name of the game/DLC/package
  # Precondition: itad_plain is the part after plain= in corresponding ITAD URL
  # (upon load, this is only called for the game whose page we are on)
  # (as user clicks on price entries, we make ajax calls for each item clicked)
  # Postcondition: The price data for input_name are added to @prices (created if nonexistent)
  def get_prices(input_name, itad_plain)
    prices = []

    if !input_name || !itad_plain
      puts "[CRITICAL] Could not find either the input_name or the itad url (must be exact!)"
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

        if !@prices
          @prices = {}
        end
        @prices[input_name] = prices
        # e.g. @prices = {"Bioshock Infinite"=>[{price entry 1}, {price entry 2}, ...], ...}

        return prices
      end
    end
  end
end