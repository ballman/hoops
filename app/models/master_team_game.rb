class MasterTeamGame < TeamGame
  def self.create_from_other(other)
    mtg = self.new(other.attributes.except('id','type'))
    other.player_games.sort {|x,y| x.id <=> y.id}.each do | pg |
      mtg.player_games<< MasterPlayerGame.new(pg.attributes.except('id','type'))
    end
    return mtg
  end
end
