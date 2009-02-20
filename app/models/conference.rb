class Conference < ActiveRecord::Base
  has_many :conference_members
  has_many :teams, :through => :conference_members, :conditions => [ "year = #{CURRENT_YEAR}" ]

  def self.table_name() "conference" end
  
  
end
