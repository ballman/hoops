class Conference < ActiveRecord::Base
  has_many :conference_memberships
  has_many :teams, :through => :conference_memberships, :conditions => [ "year = #{CURRENT_YEAR}" ]

  
end
