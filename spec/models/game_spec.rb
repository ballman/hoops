require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Game do
  describe 'as a class' do
    describe 'current games' do
      it 'should automatically limit game retrieval to those games after November 1st of the current year' do
        games = []
        (2006).upto(2010) do |year|
          games << Game.generate!(:played_on => Date.new(year, 11, 2))
        end
        Game.current.find(:all).size.should == 1
      end
    end
  end

  before :each do
    @team = Team.generate!
    @other = Team.generate!
    @game = Game.generate!
  end
  
  it 'should be able to identify a home game for a team' do
    @game.should respond_to(:home?)
  end
  
  describe 'home game for a team' do
    it 'should accept a team' do
      lambda { @game.home?(@team) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a team' do
      lambda { @game.home? }.should raise_error(ArgumentError)
    end
    
    it 'should return true if the game is a home game for the team' do
      @game.home_team = @team
      @game.home?(@team).should be_true
    end
    
    it 'should return false if the game is an away game for the team' do
      @game.away_team = @team
      @game.home?(@team).should be_false
    end
  end
  
  it 'should be able to identify an away game for a team' do
    @game.should respond_to(:away?)
  end
  
  describe 'away game for a team' do
    it 'should accept a team' do
      lambda { @game.away?(@team) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a team' do
      lambda { @game.away? }.should raise_error(ArgumentError)
    end
    
    it 'should return true if the game is an away game for the team' do
      @game.away_team = @team
      @game.away?(@team).should be_true
    end
    
    it 'should return false if the game is a home game for the team' do
      @game.home_team = @team
      @game.away?(@team).should be_false
    end
  end
end
