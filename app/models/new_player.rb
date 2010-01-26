class NewPlayer < ActiveRecord::Base
  has_one :team
  
  validates_presence_of :first_name, :last_name
  validates_inclusion_of :suffix_name, :in => %w(Jr. II III IV), 
                         :message => "{{value}} is not a valid suffix name",
                         :allow_nil => true

  validates_format_of :number, :with => /^[0-5][0-5]?$/
  validates_numericality_of :acad_year, :only_integer => true, :less_than => 6,
                            :greater_than => 0
  validates_numericality_of :height, :only_integer => true, :less_than => 92,
                            :greater_than => 60
  validates_numericality_of :weight, :only_integer => true, :less_than => 400,
                            :greater_than => 130
  validates_format_of :position, :with => /^[FGC]\/?[FGC]?$/
  
  def position=(_pos)
    all = _pos.split(/[\/-]/)
    self[:position] = all.map { |s| s[0].chr.upcase }.join('/')
  end

  def height=(_h)
    if _h.is_a? String
      f,i = _h.split('-') if (_h =~ /\d-\d\d?/)
      f,i = $1, $2 if (_h =~ /(\d)'(\d\d?)"?/)
      self[:height] =  f.to_i * 12 + i.to_i
    else
      self[:height] = _h.to_i
    end
  end

  def acad_year=(_y)
    year_hash = {'FR' => 1, 'SO' => 2, 'JR' => 3, 'SR' => 4,
                 'FRESHMAN' => 1, 'SOPHOMORE' => 2, 'JUNIOR' => 3, 'SENIOR' =>4}
    year_hash.default = 0
    if (_y.is_a? String)
      string = _y.upcase.chomp('.')
      self[:acad_year] = year_hash[string]
    else
      self[:acad_year] = _y.to_i
    end
  end

  def name=(_n)
    first_name, *last_name = _n.split
    last_name = last_name.join(' ')
    if (_n =~ /^([^,]+), *([^,]+)$/)
      last_name = $1
      first_name = $2
    end
    last_name, suffix_name = strip_suffix_name(last_name)
    self[:first_name] = first_name
    self[:last_name] = last_name
    self[:suffix_name] = suffix_name
  end

  def name
    if suffix_name.nil?
      "#{last_name}, #{first_name}"
    else
      "#{last_name}, #{first_name} #{suffix_name}"
    end
  end

  def year_string
    year_hash = {1 => "Fr.", 2 => "So.", 3 => "Jr.", 4 => "Sr.", 5 => "5th"}
    year_hash.default = "Unk"
    year_hash[acad_year]
  end

  def find_matching_player(player_list)
    player_list.detect { |p| p.first_name == first_name && p.last_name == last_name &&
                             p.suffix_name == suffix_name }
  end
  
  def strip_suffix_name(_n)
    return [_n, nil] if _n !~ / /
    all = _n.split
    if all[-1] =~ /Jr.?/ || all[-1] == 'III' ||
        all[-1] == 'IV' || all[-1] == 'II'
      [all[0..-2].join(' '), all[-1]]    else
      [all.join(' '),nil]
    end
  end
end
