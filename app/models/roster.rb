class Roster < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  
  def self.remove_player(player_id, year = nil)
    year ||= CURRENT_YEAR
    roster = Roster.find(:first, :conditions => [ 'player_id = ? and year = ?', player_id, year])
    roster.destroy()
  end
end
