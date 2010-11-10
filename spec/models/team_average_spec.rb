require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe TeamAverage do
  describe 'attributes' do
    before :each do
      @team_average = TeamAverage.new
    end
    
    it 'should have an as_of date' do
      @team_average.should respond_to(:as_of)
    end

    it 'should allow setting and reloading of as_of_date' do
      
      @team_average.as_of = date = Date.today
      @team_average.save
      @team_average.reload.as_of.should == date
    end
  end
end
