require File.expand_path(File.join(File.dirname(__FILE__), *%w[. spec_helper]))
require 'new_player_loader'

describe NewPlayerLoader do
  before :each do
    @loader = NewPlayerLoader.new
  end

  it 'should have a loader method' do 
  end

  #--------------------------------- read_player -----------------------
  describe 'read_player' do
    before :each do
      valid_player_line = '15   Borden, Frank G 6-4 180 SR  Anthony, NM (SOTP)'
      @player = @loader.parse_player_line(valid_player_line)
    end

    it 'should create a new player given a correctly formatted line' do
      @player.should_not be_nil
    end
        it 'should create a player with a first name' do
      @player.first_name.should eql('Frank')
    end
    
    it 'should create a player with a last name' do
      @player.last_name.should eql('Borden')
    end
    
    it 'should create a player with a nil suffix_name' do
      @player.suffix_name.should be_nil
    end
    
    it 'should create a player with a position' do
      @player.position.should eql('G')
    end
    
    it 'should create a player with a valid height' do
      @player.height.should eql(76)
    end
    
    it 'should create a player with a valid weight' do
      @player.weight.should eql(180)
    end
    
    it 'should create a player with a valid acad_year' do
      @player.acad_year.should eql(4)
    end
    
    it 'should create a player with a hometown' do
      @player.hometown.should eql('Anthony, NM (SOTP)')
    end

  end

  #--------------------------------- read_team -------------------------------
  it 'should set the team after seeing an appropriate line' do
    @loader.read_team('adasdsad 45 :::: adsadasdsd')
    @loader.team.should eql(45)
  end

  it 'should not set the team after seeing an inappropriate line' do
    @loader.read_team('adasdsad 45 :: :adsadasdsd')
    @loader.team.should be_nil
  end

  
end
