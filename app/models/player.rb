require 'diff/lcs'
require 'diff/lcs/string'

class Player < ActiveRecord::Base
  has_many :rosters

  has_one :player_average

  before_create :create_cstv_bs_name, :create_fox_bs_name, :create_sn_bs_name,
                :create_yahoo_bs_name

#  before_update :create_cstv_bs_name, :create_fox_bs_name, :create_sn_bs_name,
#                :create_yahoo_bs_name

  #  validates_presence_of :number, :last_name, :first_name, :position

  def team 
    rosters.where(:year => CURRENT_YEAR).first.team
  end
  
  def teams
    rosters.inject({}) do |hash, roster_entry|
      hash[roster_entry.year] = roster_entry.team
      hash
    end
  end
  
  def year_string
    year_hash = {1 => 'Fr.', 2 => 'So.', 3 => 'Jr.', 4 => 'Sr.', 5 => '5th'}
    year_hash.default = 'Unk'
    year_hash[acad_year]
  end

  def name
    name_string = last_name.nil? ? nil : "#{self.last_name}, #{self.first_name}"
    name_string += " #{self.suffix_name}" unless self.suffix_name.nil? or self.last_name.nil?
    name_string
  end

  def remove_from_current_roster
    Roster.remove_player(id)
  end

  def name_and_number
    "#{name} - #{self.number}" unless name.nil?
  end

  def last_name_closeness(other)
    closeness(self.last_name, other)
  end

  def first_name_closeness(other)
    closeness(self.first_name, other)
  end

  private
  def closeness(string, other)
    string.downcase.lcs(other.downcase).length/string.length.to_f
  end

  def create_yahoo_bs_name
    self.yahoo_bs_name = "#{self.first_name[0].chr}. #{self.last_name}"
    self.yahoo_bs_name += " #{self.suffix_name}" unless (self.suffix_name.nil? || self.suffix_name == '')
  end

  def create_cstv_bs_name
    self.cstv_bs_name = "#{self.first_name[0].chr} #{self.last_name}"
    self.cstv_bs_name += " #{self.suffix_name}" unless (self.suffix_name.nil? || self.suffix_name == '')
  end

  def create_fox_bs_name
    self.fox_bs_name = "#{self.first_name[0].chr} #{self.last_name}"
    self.fox_bs_name += " #{self.suffix_name}" unless (self.suffix_name.nil? || self.suffix_name == '')
  end

  def create_sn_bs_name
    self.sn_bs_name = "#{self.first_name} #{self.last_name}"
    self.sn_bs_name += ", #{self.suffix_name}" unless (self.suffix_name.nil? || self.suffix_name == '')
  end
end
