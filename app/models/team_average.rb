class TeamAverage < ActiveRecord::Base
  belongs_to :team

  def self.stat_columns
    %w(half1_point half2_point total_point fgm fga fgp tpm tpa tpp 
       ftm fta ftp offense_rebound total_rebound assist steal block turnover foul)
  end
  def self.percent_hash
    %w(fgp tpp ftp).inject({}) {|h,w| h[w] = true; h}
  end
end
