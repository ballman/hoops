require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Player do
  before :each do
    @new_player = Player.new 
    @valid_player = Player.new(:number => 1, :first_name => 'A',
                               :last_name => 'B', :position => 'C',
                               :height => 72, :weight => 200, :acad_year => 3,
                               :hometown => 'D')
  end

  describe 'getting the year as a string' do
    it 'should respond "Fr." for player with academic year 1.' do
      @valid_player.acad_year = 1
      @valid_player.year_string.should eql('Fr.')
    end

    it 'should respond "So." for player with academic year 2.' do
      @valid_player.acad_year = 2
      @valid_player.year_string.should eql('So.')
    end

    it 'should respond "Jr." for player with academic year 3.' do
      @valid_player.acad_year = 3
      @valid_player.year_string.should eql('Jr.')
    end

    it 'should respond "Sr." for player with academic year 4.' do
      @valid_player.acad_year = 4
      @valid_player.year_string.should eql('Sr.')
    end

    it 'should respond "5th" for player with academic year 5.' do
      @valid_player.acad_year = 5
      @valid_player.year_string.should eql('5th')
    end

    it 'should respond "Unk" for player with academic year less than 1.' do
      @valid_player.acad_year = 0
      @valid_player.year_string.should eql('Unk')
    end

    it 'should respond "Unk" for player with academic year greater than 5.' do
      @valid_player.acad_year = 6
      @valid_player.year_string.should eql('Unk')
    end
  end

  describe 'team method should return the current team' do
    it 'With a valid list of teams it should return the first' do
      @valid_player.stubs(:team).returns(Team.new(:name => 'Correct'))
      @valid_player.team.name.should eql('Correct')
    end
  end

  describe 'teams method should return a hash of year => team' do
    before :each do
      @valid_player.stubs(:rosters).returns([Roster.new(:team_id => 1, :player_id => 1, :year => 2008),
                                            Roster.new(:team_id => 2, :player_id => 2, :year => 2007),])
      Roster.any_instance.stubs(:team).returns(Team.new(:name => "Correct"))
    end
    
    it 'should return a hash' do
      @valid_player.teams.should be_a_kind_of Hash
    end

    it 'should return a hash with 2 keys' do
      @valid_player.teams.should have(2).items
    end

    it 'should return a hash with key of 2008' do
      @valid_player.teams[2008].name.should eql "Correct"
    end
  end

  describe 'name formats the first, last, and suffix name' do
    it 'should return the correct format for a player without a suffix name' do
      @valid_player.name.should eql('B, A')
    end

    it 'should return the correct format for a player with a suffix name' do
      @valid_player.suffix_name = 'Jr.'
      @valid_player.name.should eql('B, A Jr.')
    end

    it 'should return nil for a player missing a last name' do
      @valid_player.last_name = nil
      @valid_player.name.should be_nil
    end

    it 'should return nil for a player missing a last name, even if suffix_name is valid' do
      @valid_player.last_name = nil
      @valid_player.suffix_name = "Jr."
      @valid_player.name.should be_nil
    end
  end

  describe 'name_and_number formats the name with the number' do
    it 'should return name - number for player without a suffix' do
      @valid_player.name_and_number.should eql('B, A - 1')
    end

    it 'should return name - number for player with a suffix' do
      @valid_player.suffix_name = "Jr."
      @valid_player.name_and_number.should eql('B, A Jr. - 1')
    end

    it 'should return nil for a player missing a last name' do
      @valid_player.last_name = nil
      @valid_player.name_and_number.should be_nil
    end
  end
end
