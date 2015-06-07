module MainHelper
  
  def has_dlc?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["dlc"]
      return true
    end
    return false
  end

  def get_dlc(hash,id)
    return hash[id.to_s]["data"]["dlc"]
  end

  def has_name?(hash,dlc)
    if hash && hash[dlc.to_s] && hash[dlc.to_s]["data"] && 
      hash[dlc.to_s]["data"]["name"]
        return true
    end
    return false
  end

  def get_name(hash,dlc)
    return hash[dlc.to_s]["data"]["name"]
  end

  def has_metacritic?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && 
      hash[id.to_s]["data"]["metacritic"] &&
      hash[id.to_s]["data"]["metacritic"]["score"] &&
      hash[id.to_s]["data"]["metacritic"]["url"]
      return true
    end
    return false
  end

  def get_metacritic_url(hash,id)
    return hash[id.to_s]["data"]["metacritic"]["url"]
  end

  def get_metacritic_score(hash,id)
    return hash[id.to_s]["data"]["metacritic"]["score"]
  end
  #
  def has_description?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["detailed_description"]
      return true
    end
    return false
  end

  def get_description(hash,id)
    return hash[id.to_s]["data"]["detailed_description"]
  end
  #
  def has_reviews?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["reviews"]
      return true
    end
    return false
  end

  def get_reviews(hash,id)
    return hash[id.to_s]["data"]["reviews"]
  end
  #
  def has_website?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["website"]
      return true
    end
    return false
  end

  def get_website(hash,id)
    return hash[id.to_s]["data"]["website"]
  end

  #
  def has_min_req?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && 
       hash[id.to_s]["data"]["pc_requirements"] && 
       hash[id.to_s]["data"]["pc_requirements"] != [] && 
       hash[id.to_s]["data"]["pc_requirements"]["minimum"]
      return true
    end
    return false
  end

  def get_min_req(hash,id)
    return hash[id.to_s]["data"]["pc_requirements"]["minimum"]
  end
  #
  def has_rec_req?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && 
      hash[id.to_s]["data"]["pc_requirements"] && 
      hash[id.to_s]["data"]["pc_requirements"] != [] &&
      hash[id.to_s]["data"]["pc_requirements"]["recommended"]
      return true
    end
    return false
  end

  def get_rec_req(hash,id)
    return hash[id.to_s]["data"]["pc_requirements"]["recommended"]
  end
  #
  def has_legal_notice?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["legal_notice"]
      return true
    end
    return false
  end

  def get_legal_notice(hash,id)
    return hash[id.to_s]["data"]["legal_notice"]
  end
  #
  def has_release_date?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["release_date"] && hash[id.to_s]["data"]["release_date"]["date"]
      return true
    end
    return false
  end

  def get_release_date(hash,id)
    return hash[id.to_s]["data"]["release_date"]["date"]
  end
  #
  def has_packages?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["packages"]
      return true
    end
    return false
  end

  def get_packages(hash,id)
    return hash[id.to_s]["data"]["packages"]
  end
  #
  def has_developer?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["developers"]
      return true
    end
    return false
  end

  def get_developer(hash,id)
    return hash[id.to_s]["data"]["developers"]
  end
  #
  def has_header_image?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && hash[id.to_s]["data"]["header_image"]
      return true
    end
    return false
  end

  def get_header_image(hash,id)
    return hash[id.to_s]["data"]["header_image"]
  end
  #
  def has_recommendation?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && 
      hash[id.to_s]["data"]["recommendations"] && 
      hash[id.to_s]["data"]["recommendations"]["total"]
      return true
    end
    return false
  end

  def get_recommendation(hash,id)
    return hash[id.to_s]["data"]["recommendations"]["total"].to_i
  end

  def has_packages?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && 
      hash[id.to_s]["data"]["packages"]
      return true
    end
    return false
  end

  def get_packages(hash,id)
    return hash[id.to_s]["data"]["packages"]
  end

  def has_type?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && 
      hash[id.to_s]["data"]["type"]
      return true
    end
    return false
  end

  def get_type(hash,id)
    return hash[id.to_s]["data"]["type"]
  end

  def has_apps?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && 
      hash[id.to_s]["data"]["apps"]
      return true
    end
    return false
  end

  def get_apps(hash,id)
    return hash[id.to_s]["data"]["apps"]
  end

  def has_small_logo?(hash,id)
    if hash && hash[id.to_s] && hash[id.to_s]["data"] && 
      hash[id.to_s]["data"]["small_logo"]
      return true
    end
    return false
  end

  def get_small_logo(hash,id)
    return hash[id.to_s]["data"]["small_logo"]
  end

end
