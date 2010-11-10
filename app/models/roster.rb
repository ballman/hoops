class Roster < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  
  def self.remove_player(player_id, year = nil)
    year ||= CURRENT_YEAR
    roster = Roster.where(:player_id => player_id, :year => year).first
    roster.destroy()
  end
end
