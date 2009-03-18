require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe TeamHelper do
  it 'should provide a means of drawing a team graph' do
    helper.should respond_to(:team_stats_graph)
  end

  describe 'when drawing a team graph' do
    before :each do
      @team = Team.generate!
      @title = 'Test Title'
      @column = :ppp

      helper.stubs(:draw_stats_graph)
      TeamAverage.stubs(:minimum).returns(0)
      TeamAverage.stubs(:maximum).returns(0)
      TeamFoeAverage.stubs(:minimum).returns(0)
      TeamFoeAverage.stubs(:maximum).returns(0)
    end
    
    it 'should allow a team, a title and an averages column name' do
      lambda { helper.team_stats_graph(@team, @title, @column)}.should_not raise_error(ArgumentError)
    end

    it 'should require an averages column name' do
      lambda { helper.team_stats_graph(@team, @title) }.should raise_error(ArgumentError)
    end

    it 'should require a title' do
      lambda { helper.team_stats_graph(@team) }.should raise_error(ArgumentError)
    end

    it 'should require a team' do
      lambda { helper.team_stats_graph }.should raise_error(ArgumentError)
    end

    it 'should call draw_graph' do
      helper.expects(:draw_stats_graph)
      helper.team_stats_graph(@team, @title, @column)
    end
  end
  
  it 'should provide a means of drawing a graph' do
    helper.should respond_to(:draw_stats_graph)
  end

  describe 'when drawing a graph' do
    before :each do
      values_1 = [1, 2, 3, 4, 5]
      values_2 = [6, 7, 8, 9, 10]
      @dates = ['11/1', '11/2', '11/3', '11/4', '11/5']
      @hash = { 'offense' => values_1.zip(@dates), 'defense' => values_2.zip(@dates)}
      @title = 'Test Title'
      @options = { :minimum_value => 0, :maximum_value => 3 }
    end

    it 'should allow a title, a series hash, and an options hash' do
      lambda { helper.draw_stats_graph(@title, @hash, @options)}.should_not raise_error(ArgumentError)
    end

    it 'should require a series hash' do
      lambda { helper.draw_stats_graph(@title) }.should raise_error(ArgumentError)
    end

    it 'should require a title' do
      lambda { helper.draw_stats_graph }.should raise_error(ArgumentError)
    end

    it 'should allow options to be, um, optional' do
      lambda { helper.draw_stats_graph(@title, @hash) }.should_not raise_error(ArgumentError)
    end

    it 'should return a javascript graph specification' do
      helper.draw_stats_graph(@title, @hash, @options).should match(%r{<script})
    end

    describe 'the returned graph' do
      it 'should include the graph title' do
        helper.draw_stats_graph(@title, @hash, @options).should match(Regexp.new(Regexp.escape(@title)))
      end

      it 'should escape the graph title'

      it 'should include each hash key as a graph label' do
        result = helper.draw_stats_graph(@title, @hash, @options)
        @hash.keys.each do |key|
          result.should match(Regexp.new(Regexp.escape(key)))
        end
      end

      it 'should escape the hash keys'

      it 'should include the data points in each hash value' do
        result = helper.draw_stats_graph(@title, @hash, @options)
        @hash.each_pair do |key,value|
          result.should match(Regexp.new("#{key}.*#{Regexp.escape(value.collect(&:first).inspect)}"))
        end
      end

      it 'should set any options provided' do
        result = helper.draw_stats_graph(@title, @hash, @options)
        @options.each_pair do |key, value|
          result.should match(Regexp.new("#{key}.*=.*#{value}"))
        end
      end
    end
  end
end
