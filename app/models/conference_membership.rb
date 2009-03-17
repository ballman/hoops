class ConferenceMembership < ActiveRecord::Base
  belongs_to :conference
  belongs_to :team
  
end
