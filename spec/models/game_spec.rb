require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Game do
  describe 'as a class' do
    describe 'current games' do
      it 'should automatically limit game retrieval to those games after 2008-11-01' do
        games = []
        (2006).upto(2008) do |year|
          games << Game.generate!(:played_on => Date.new(year, 11, 2))
        end

        Game.current.find(:all).size.should == 1
      end
    end
  end
end
