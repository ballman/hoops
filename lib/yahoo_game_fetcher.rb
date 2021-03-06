class YahooGameFetcher < GameFetcher
  URL = 'rivals.yahoo.com'

  def get_game_list_html(game_date, url, conference_id='all')
    path = sprintf('/ncaa/basketball/scoreboard?d=%s&c=all',
                  game_date.strftime("%Y-%m-%d"))
    puts "ARB {PATH} ::: #{path}"
    Net::HTTP.start(URL) do | http |
#      http.timeout = 300
      http.read_timeout = 300
      http.get(path).body
    end
  end

  def create_game_list(html)
    games = Array.new
    html.grep(/<a href=\"([^\"]*)?\"[^>]*>Box Score/m) { | match | games << $1 } unless (html.nil?)
    games.each { |g| g.sub!(/^\/ncaab/, "/ncaa/basketball") }
    games.each { |g| puts "ARB ::: #{g}" }
    return games
  end

  def get_game_source_id(url)
    $1 if (url =~ /\?gid=(\d+)/)
  end

  def loaded_games(date)
    YahooGameFile.find(:all, :conditions => [ "game_date = ?", date ]).collect do | game |
      game.source_id
    end
  end

  def create_game_file(date, content, source_id)
    YahooGameFile.new(:game_date => date, :content => content, :source_id => source_id)
  end
end
