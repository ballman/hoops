class Team < ActiveRecord::Base
  has_many :conference_members
  has_many :historic_conferences, :through => :conference_members, :source => :conference
  has_many :conferences, :through => :conference_members, :conditions => [ "year = #{CURRENT_YEAR}" ]

  has_many :rosters
  has_many :players, :through => :rosters, :conditions => [ "year = #{CURRENT_YEAR}" ]

  has_one :stats, :class_name => 'TeamAverage'
  has_one :opp_stats, :class_name => 'TeamFoeAverage'


  def self.table_name() "team" end

  def <=>(other)
      return self.name <=> other.name
  end

  def conference
    conferences[0] unless conferences.nil?
  end

end
