require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Team do
  describe 'associations' do
    before :each do
      @team = Team.generate!
    end

    it 'should have many team averages' do
      @team.should respond_to(:team_averages)
    end

    it 'should have many team foe averages' do
      @team.should respond_to(:team_foe_averages)
    end

    it 'should limit stats to the most recent team average data' do
      2006.upto(2008) do |year|
        @team.team_averages.generate!(:as_of => Date.new(year, 11, 1))
      end

      @team.stats.as_of.should == Date.new(2008, 11, 1)
    end

    it 'should limit opponent stats to the most recent team foe average data' do
      2006.upto(2008) do |year|
        @team.team_foe_averages.generate!(:as_of => Date.new(year, 11, 1))
      end

      @team.opp_stats.as_of.should == Date.new(2008, 11, 1)
    end
  end
end
