gem 'diff-lcs'
require 'diff/lcs'
require 'diff/lcs/string'

class Player < ActiveRecord::Base
  has_many :rosters
  has_many :teams, :through => :rosters, :conditions => [ "roster.year = #{CURRENT_YEAR}" ]

  has_one :player_average

  before_create :create_cstv_bs_name, :create_fox_bs_name, :create_sn_bs_name


  #  validates_presence_of :number, :last_name, :first_name, :position
  def self.table_name()  "player" end

  def year_string()
    case self.acad_year
    when 1 then "Fr."
    when 2 then "So."
    when 3 then "Jr."
    when 4 then "Sr."
    when 5 then "5th"
    else        "NA"
    end
  end

  def team
    return teams[0] unless teams.nil?
  end

  def name
    "#{self.last_name}, #{self.first_name} #{self.suffix_name}" unless self.last_name.nil?
  end

  def name_and_number
    "#{self.last_name}, #{self.first_name} #{self.suffix_name} - #{self.number}" unless self.last_name.nil?
  end

  def last_name_closeness(other)
    closeness(self.last_name, other)
  end

  def first_name_closeness(other)
    closeness(self.first_name, other)
  end

  def remove_from_current_roster
    Roster.remove_player(id)
  end

  private
  def closeness(string, other)
    string.downcase.lcs(other.downcase).length/string.length.to_f
  end

  def create_cstv_bs_name
    self.cstv_bs_name = "#{self.first_name[0].chr} #{self.last_name}"
    self.cstv_bs_name += " #{self.suffix_name}" if self.suffix_name != ''
  end

  def create_fox_bs_name
    self.fox_bs_name = "#{self.first_name[0].chr} #{self.last_name}"
    self.fox_bs_name += " #{self.suffix_name}" if self.suffix_name != ''
  end

  def create_sn_bs_name
    self.sn_bs_name = "#{self.first_name} #{self.last_name}"
    self.sn_bs_name += ", #{self.suffix_name}" if self.suffix_name != ''
  end
end
