class Team < ActiveRecord::Base
  has_many :conference_memberships
  has_many :historic_conferences, :through => :conference_memberships, :source => :conference
  has_many :conferences, :through => :conference_memberships, :conditions => [ "year = #{CURRENT_YEAR}" ]

  has_many :rosters
  has_many :players, :through => :rosters, :conditions => [ "year = #{CURRENT_YEAR}" ]

  has_many :team_averages
  has_many :team_foe_averages
  has_one :stats, :class_name => 'TeamAverage', :order => 'as_of DESC'
  has_one :opp_stats, :class_name => 'TeamFoeAverage', :order => 'as_of DESC'

  has_many :team_games, :conditions => ["type = 'MasterTeamGame'" ]
  has_many :games, :through => :team_games
  def <=>(other)
      return self.name <=> other.name
  end

  def conference
    conferences[0] unless conferences.nil?
  end

end
