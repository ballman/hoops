require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe NewPlayer do
  before :each do
    @new_player = NewPlayer.new 
    @valid_player = NewPlayer.new(:number => 1, :first_name => 'A',
                                  :last_name => 'B', :position => 'C',
                                  :height => 72, :weight => 200, :acad_year => 3,
                                  :hometown => 'D', :team_id => 1)

  end

  it 'should create new player' do
    @new_player.should_not be_nil
  end

  #------------------ position= ----------------------
  it 'should find the first character(upcase) of position(no /)' do
    @new_player.position = 'forward'
    @new_player.position.should eql('F')
  end

  it 'should find the only character(upcase) if length is 1' do
    @new_player.position = 'g'
    @new_player.position.should eql('G')
  end

  it 'should find all the positions when there is a /' do
    @new_player.position = 'Guard/forward'
    @new_player.position.should eql('G/F')
  end

  it 'should find all the positions when there is a /' do
    @new_player.position = 'G-F'
    @new_player.position.should eql('G/F')
  end

  it 'should find all the positions when there is a /' do
    @new_player.position = 'Forward-center'
    @new_player.position.should eql('F/C')
  end

    #------------------ height= ----------------------
  it 'should convert height of form F-I to inches' do
    @new_player.height= '6-7'
    @new_player.height.should eql(79)
  end

  it 'should convert height of form F\'I" to inches' do
    @new_player.height = '6\'11"'
    @new_player.height.should eql(83)
  end

  it 'should convert height of form F\'I to inches' do
    @new_player.height = '5\'9'
    @new_player.height.should eql(69)
  end

  it 'should convert height to 0 if form not f-i or f\'i"' do
    @new_player.height = 'junk'
    @new_player.height.should eql(0)
  end

  it 'should set the height to the number passed' do
    @new_player.height = 71
    @new_player.height.should eql(71)
  end

    #------------------ year= ----------------------
  it 'should convert year \'fr*\' or \'freshman\' to 1' do
    @new_player.acad_year = 'fr.'
    @new_player.acad_year.should eql(1)
    @new_player.acad_year = 'Freshman'
    @new_player.acad_year.should eql(1)
  end

  it 'should convert year \'so\' or \'junior\' to 2' do
    @new_player.acad_year = 'so.'
    @new_player.acad_year.should eql(2)
    @new_player.acad_year = 'sophomore'
    @new_player.acad_year.should eql(2)
  end

  it 'should convert year \'jr\' or \'junior\' to 3' do
    @new_player.acad_year = 'jr.'
    @new_player.acad_year.should eql(3)
    @new_player.acad_year = 'junior'
    @new_player.acad_year.should eql(3)
  end
  
  it 'should convert year \'sr.?\' or "senior" to 4' do
    @new_player.acad_year = 'sr.'
    @new_player.acad_year.should eql(4)
    @new_player.acad_year = 'senior'
    @new_player.acad_year.should eql(4)
  end

  it 'should convert year the is junk to 0' do
    @new_player.acad_year = 'junk'
    @new_player.acad_year.should eql(0)
  end

  it 'should set the acad_year to any number passed' do
    @new_player.acad_year = 17
    @new_player.acad_year.should eql(17)
  end

  #---------------------------- name= -------------------------------
  it 'should set first_name=A, last_name=B, suffix_name=nil for "A B"' do
    @new_player.name = 'A B'
    @new_player.first_name.should eql('A')
    @new_player.last_name.should eql('B')
    @new_player.suffix_name.should be_nil
  end

  it 'should set first_name=A, last_name=B, suffix_name=nil for "B, A"' do
    @new_player.name = 'B, A'
    @new_player.first_name.should eql('A')
    @new_player.last_name.should eql('B')
    @new_player.suffix_name.should be_nil
  end

  it 'should set first_name=A, last_name=B, suffix_name=nil for "B, A"' do
    @new_player.name = 'B, A'
    @new_player.first_name.should eql('A')
    @new_player.last_name.should eql('B')
    @new_player.suffix_name.should be_nil
  end

  it 'should set first_name=A, last_name=B C, suffix_name=nil for "B C, A"' do
    @new_player.name = 'B C, A'
    @new_player.first_name.should eql('A')
    @new_player.last_name.should eql('B C')
    @new_player.suffix_name.should be_nil
  end

    it 'should set multiple first name with comma correctly' do
    @new_player.name = 'B C, A D'
    @new_player.first_name.should eql('A D')
    @new_player.last_name.should eql('B C')
    @new_player.suffix_name.should be_nil
  end    

  it 'should set first_name=A, last_name=B C, suffix_name="Jr." for "B C Jr., A"' do
    @new_player.name = 'B C Jr., A'
    @new_player.first_name.should eql('A')
    @new_player.last_name.should eql('B C')
    @new_player.suffix_name.should eql('Jr.')
  end

  it 'should set first_name=A, last_name=B, suffix_name="Jr." for "A B Jr."' do
    @new_player.name = 'A B Jr.'
    @new_player.first_name.should eql('A')
    @new_player.last_name.should eql('B')
    @new_player.suffix_name.should eql('Jr.')
  end

    #_---------------------------- suffix_name -------------------------------
  it 'should take Jr. last as a suffix name' do
    last, suffix = @new_player.strip_suffix_name('A Jr.')
    last.should eql('A')
    suffix.should eql('Jr.')
  end

  it 'should take II last as a suffix name' do
    last, suffix = @new_player.strip_suffix_name('A B II')
    last.should eql('A B')
    suffix.should eql('II')
  end

  it 'should take III last as a suffix name' do
    last, suffix = @new_player.strip_suffix_name('A B III')
    last.should eql('A B')
    suffix.should eql('III')
  end

  it 'should take IV last as a suffix name' do
    last, suffix = @new_player.strip_suffix_name('A-B IV')
    last.should eql('A-B')
    suffix.should eql('IV')
  end

  it 'should not have a suffix if it doesn\'t end with Jr, III, or IV' do
    last, suffix = @new_player.strip_suffix_name('A B')
    last.should eql('A B')
    suffix.should be_nil
  end

  it 'should return a single name as the last and no suffix' do
    last, suffix = @new_player.strip_suffix_name('Jr.')
    last.should eql('Jr.')
    suffix.should be_nil
  end
  #---------------------------- validation ------------------------------
  it 'should be a valid player' do
    @valid_player.should be_valid
  end

  it 'should not be valid without a first name' do
    @valid_player.first_name = nil
    @valid_player.should_not be_valid
  end

  it 'should not be valid without a last name' do
    @valid_player.last_name = nil
    @valid_player.should_not be_valid
  end

  it 'should be valid with a suffix of IV' do
    @valid_player.suffix_name = 'IV'
    @valid_player.should be_valid
  end

  it 'should not be valid with a bad suffix' do
    @valid_player.suffix_name = 'Bad'
    @valid_player.should_not be_valid
  end

  it 'should not be valid with a big number' do
    @valid_player.number = 100
    @valid_player.should_not be_valid
  end    

  it 'should not be valid with a big year' do
    @valid_player.acad_year = 6
    @valid_player.should_not be_valid
  end

  it 'should not be valid with a small height' do
    @valid_player.height = 48
    @valid_player.should_not be_valid
  end

  it 'should not be valid with a small weight' do
    @valid_player.weight = 128
    @valid_player.should_not be_valid
  end

  it 'should not be valid with a bogus position' do
    @valid_player.position = 'B'
    @valid_player.should_not be_valid
  end

  it 'should be valid with a split position' do
    @valid_player.position = 'G/F'
    @valid_player.should be_valid
  end

  describe "name" do
    it 'should return the last, first name for player without suffix' do
      @valid_player.name.should eql("B, A")
    end

    it 'should return the last, first name suffix_name for player without suffix' do
      @valid_player.suffix_name = 'Jr.'
      @valid_player.name.should eql("B, A Jr.")
    end
  end

  describe "year string" do
    it "should return 'Fr.' for players with year of 1" do
      @valid_player.acad_year = 1
      @valid_player.year_string.should eql("Fr.")
    end

    it "should return 'So.' for players with year of 2" do
      @valid_player.acad_year = 2
      @valid_player.year_string.should eql("So.")
    end

    it "should return 'Jr.' for players with year of 3" do
      @valid_player.acad_year = 3
      @valid_player.year_string.should eql("Jr.")
    end

    it "should return 'Sr.' for players with year of 4" do
      @valid_player.acad_year = 4
      @valid_player.year_string.should eql("Sr.")
    end

    it "should return '5th' for players with year of 5" do
      @valid_player.acad_year = 5
      @valid_player.year_string.should eql("5th")
    end

    it "should return 'Unk' for players with years < 1" do
      @valid_player.acad_year = 0
      @valid_player.year_string.should eql("Unk")
    end      

    it "should return 'Unk' for players with years > 5" do
      @valid_player.acad_year = 6
      @valid_player.year_string.should eql("Unk")
    end      
  end

  describe 'find_matching_player' do
    it 'should return nil if passed an empty list' do
      @valid_player.find_matching_player([]).should be_nil
    end

    it 'should return the a player with matching first, last, and suffix names in the list of 1.' do
      @valid_player.find_matching_player([@valid_player]).should equal(@valid_player)
    end

    it 'should return the a player with matching first, last, and suffix names in a list of more than 1.' do
      @valid_player.find_matching_player([@new_player, @valid_player]).should equal(@valid_player)
    end

    it 'should return nil is no player in list matches first, last, and suffix names.' do
      @valid_player.find_matching_player([@new_player]).should be_nil
    end
  end
end

