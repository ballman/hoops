class CstvGameFetcher < GameFetcher
  URL = 'www.cbssports.com'

  def get_game_list_html(game_date, url)
    path = sprintf('/collegebasketball/scoreboard/div1/%s',
          game_date.strftime("%Y%m%d"))
    Net::HTTP.start(URL) { | http | http.get(path).body }
  end

  def create_game_list(html)
    games = Array.new
    html.grep(/<a href=\"([^\"]*)?\"[^>]*>Box Score/m) { | match | games << $1 } unless (html.nil?)
    return games
  end

  def get_game_source_id(url)
    $1 + "_" + $2 + "_" + $3 if (url =~ /\/([^\/]*)\/(\d*)_game_boxscore_(.*)\.html$/)
  end

  def loaded_games(date)
    CstvGameFile.find(:all, :conditions => [ "game_date = ?", date ]).collect do | game |
      game.source_id
    end
  end

  def create_game_file(date, content, source_id)
    CstvGameFile.new(:game_date => date, :content => content, :source_id => source_id)
  end
end
