module FrontPage
  
  def has_large_capsules?(hash)
    if hash && hash["large_capsules"]
      return true
    end
    return false
  end

  def get_large_capsules(hash)
    return hash["large_capsules"]
  end

  def has_id?(cap)
    if cap && cap["id"]
      return true
    end
    return false
  end

  def get_id(cap)
    return cap["id"]
  end

  def has_top_sellers?(hash)
    if hash && hash["top_sellers"] && hash["top_sellers"]["items"]
      return true
    end
    return false
  end

  def get_top_sellers(hash)
    return hash["top_sellers"]["items"]
  end

  def has_specials?(hash)
    if hash && hash["specials"] && hash["specials"]["items"]
      return true
    end
    return false
  end

  def get_specials(hash)
    return hash["specials"]["items"]
  end

  def valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue Exception => e
      return false
    end
  end

  def page_refresh_no_id(uri,max_time)
    time = Time.now+max_time.seconds
    resp = Net::HTTP.get_response(uri)
    while Time.now<time && resp.body == "null" do 
      resp = Net::HTTP.get_response(uri)
    end
    if resp.body == "null" || resp.class == Net::HTTPBadRequest
      return nil
    end
    if !valid_json?(resp.body)
      return page_refresh(uri,max_time,id,is_dlc_id)
    end
    return resp.body
  end

  #Precondition: MUST CALL get_frontpage_deals first
  #Postcondition: Merges with @large_capsules.
  def get_more_frontpage_info()
    specials = []
    top_sellers = []
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
    else
      puts "ERROR: PLEASE RELOAD WEBSITE"
    end
    @large_capsules = 
    (@large_capsules | specials | top_sellers).uniq
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
end