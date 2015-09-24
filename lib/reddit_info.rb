module RedditInfo

  #Precondition: name is the name of the game. MUST BE VALID
  #Postcondition: creates instance variables
  # @post_links for the links of the reddit posts
  # @post_names for the titles
  # @comment_links for the link to the comments
  def get_reddit_info(name)
    @post_names = []
    @post_links = []
    @comment_links = []
    base_url = "https://www.reddit.com/r/"
    game = Game.find_by(name:name)
    base_url += game.subreddit + "/top?sort=top&t=month"

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
  
end