require 'google/api_client'
require 'trollop'
module YoutubeInfo

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
  
end