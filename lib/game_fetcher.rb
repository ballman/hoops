require 'net/http'

class GameFetcher

  # do not override this method.
  def get_games(game_date, url, conference_id='all')
    games = Array.new
    game_list = create_game_list(get_game_list_html(game_date, url, conference_id))
    loaded_games = loaded_games(game_date)
    game_list.each do | game_url |
      next if (loaded_games.include?(get_game_source_id(game_url)))
      game_file = retrieve_game_file(game_url, url)
      game = create_game_file(game_date, game_file, get_game_source_id(game_url))
      game.save
      games << game
    end
    return games
  end

  def retrieve_game_file(path, url)
    Net::HTTP.start(url) do |http|
      http.read_timeout = 300
      response = http.get(path)
      response.body
    end
  end

  # override this method
  def create_game_file(date, content, source_id)
    raise NotImplementedError("GameFetcher::create_game_file must be overriden")
  end

  # override this method
  def get_game_list_html(game_date, url, conference_id='all')
    raise NotImplementedError("GameFetcher::get_game_list_html must be overriden")
  end

  # override this method
  def create_game_list(game_date)
    raise NotImplementedError("GameFetcher::create_game_list must be overriden")
  end

  # override this method
  def get_game_source_id(url)
    raise NotImplementedError("GameFetcher::get_game_source_id must be overriden")
  end

  # override this method
  def loaded_games(date)
    raise NotImplementedError("GameFetcher::loaded_games must be overriden")
  end

  # override this method
  def create_game_file(date, content, source_id)
    raise NotImplementedError("GameFetcher::create_game_file must be overriden")
  end
end
