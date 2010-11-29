class SportsNetworkGameFetcher < GameFetcher
  URL = 'www.sportsnetwork.com'

  def get_game_list_html(game_date, url)
    path = sprintf('/merge/tsnform.aspx?c=sportsnetwork&misc=11&page=cbask/scores/live/scoreboard.aspx?date=%s',
                   game_date.strftime("%m%d%y"))
    Net::HTTP.start(URL) do | http |
      http.get(path).body
    end
  end

  def create_game_list(html)
    html.split(/<\/[Aa]>/).grep(/<[Aa] href=\"([^\"]*)?\"[^>]*>Box$/) do | match |
      $1
    end
  end

  def get_game_source_id(url)
    $1 if (url =~ /\?GAMEID=(\d+)/)
  end

  def loaded_games(date)
    SportsNetworkGameFile.find(:all,
              :conditions => [ "game_date = ?", date ]).collect do | game |
      game.source_id
    end
  end

  def create_game_file(date, content, source_id)
    SportsNetworkGameFile.new(:game_date => date, :content => content, :source_id => source_id)
  end
end
