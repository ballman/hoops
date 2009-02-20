class TeamFoeAverage < ActiveRecord::Base
  belongs_to :team

  def self.stat_columns
    TeamAverages.stat_columns
  end

  def self.percent_hash
    TeamAverages.percent_hash
  end
end
