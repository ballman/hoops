require 'net/http'

class FoxGameFetcher < GameFetcher
  URL = 'msn.foxsports.com'

  def get_game_list_html(game_date, url)
    path = '/collegebasketball/scores?scheduleDayCode=' + game_date.strftime("%Y-%m-%d") +
	   '&conference=all'
    Net::HTTP.start(url) do |http|
      response = http.get(path)
      response.body
    end
  end

  def create_game_list(html)
    games = Array.new
    html.grep(/<a href=\"([^>]*)\">Box Score/m) do | match |
      games << $1.sub(/cbk/, 'collegebasketball')
    end
    return games
  end

  def create_game_file(date, content, source_id)
    return FoxGameFile.new(:game_date => date, :content => content, :source_id => source_id)
  end

  def loaded_games(date)
    FoxGameFile.find(:all, :conditions => [ "game_date = ?", date ]).collect do | game |
      game.source_id
    end
  end

  def get_game_source_id(url)
    url.slice(url.index("=") + 1..-1)
  end
end
