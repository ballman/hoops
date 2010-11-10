class TeamAverage < ActiveRecord::Base
  belongs_to :team

  def self.stat_columns
    %w(total_point fgm fga fgp tpm tpa tpp 
       ftm fta ftp offense_rebound total_rebound assist steal block turnover foul
       ppp get_ft orp to_rate poss)
  end
  
  def self.percent_hash
    %w(fgp tpp ftp).inject({}) {|h,w| h[w] = true; h}
  end
end
