class ConferenceMember < ActiveRecord::Base
  belongs_to :conference
  belongs_to :team
  
  def self.table_name() "conference_membership" end
end
