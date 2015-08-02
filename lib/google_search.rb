module GoogleSearch

  #Precondition: name is the name of a game,start_time is the time
  #of the first call to this method
  #Postcondition: returns array filled with top 10 google results
  def google_info(name,start_time)
    google_links = []
    count = 0
    begin
      Google::Search::Web.new(:query => (name + " reviews")).each do |web|
        if !web.uri.include?("reddit") &&
          !web.uri.include?("wikipedia") && 
          !web.uri.include?("youtube") &&
          !web.uri.include?("metacritic") && count<10
          google_links << web.uri
          count+=1
        end
      end
    rescue
      if Time.now<start_time+5.seconds
        sleep(0.2)
        google_info(name,start_time,false)
      else 
        return google_links
      end
    end
    return google_links
  end

  #Precondition: name is the name of a game,start_time is the time
  #of the first call to this method
  #Postcondition: returns array filled with google image links
  def google_image_info(name,start_time)
    google_image_links = []
    count = 0
    begin
      Google::Search::Image.new(:query => (name+" gameplay")).each do |image|
        if image.width > 700 
          google_image_links<< image.uri
          count+=1
        end
        if count>15
          break
        end
      end
    rescue
      if Time.now<start_time+8.seconds
        sleep(0.2)
        google_image_info(name,start_time,false)
      else 
        return google_image_links
      end
    end
    return google_image_links
  end

end