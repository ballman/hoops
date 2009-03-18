require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe TeamHelper do
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
    end

    it 'should allow a title and a series hash' do
      lambda { helper.draw_stats_graph(@title, @hash)}.should_not raise_error(ArgumentError)
    end

    it 'should require a series hash' do
      lambda { helper.draw_stats_graph(@title) }.should raise_error(ArgumentError)
    end

    it 'should require a title' do
      lambda { helper.draw_stats_graph }.should raise_error(ArgumentError)
    end

    it 'should return a javascript graph specification' do
      helper.draw_stats_graph(@title, @hash).should match(%r{<script})
    end

    describe 'the returned graph' do
      it 'should include the graph title' do
        helper.draw_stats_graph(@title, @hash).should match(Regexp.new(Regexp.escape(@title)))
      end

      it 'should escape the graph title'

      it 'should include each hash key as a graph label' do
        result = helper.draw_stats_graph(@title, @hash)
        @hash.keys.each do |key|
          result.should match(Regexp.new(Regexp.escape(key)))
        end
      end

      it 'should escape the hash keys'

      it 'should include the data points in each hash value' do
        result = helper.draw_stats_graph(@title, @hash)
        @hash.each_pair do |key,value|
          result.should match(Regexp.new("#{key}.*#{Regexp.escape(value.collect(&:first).inspect)}"))
        end
      end

      it 'should include the x-axis data for each hash value' do
        result = helper.draw_stats_graph(@title, @hash)
        @dates.each do |date|
          result.should match(Regexp.new(Regexp.escape(date)))
        end
      end
    end
  end
end

__END__

'Efficiency',
{
  'Offensive' => [[ '11/01', 12], ['11/02', 13']]
  'Defensive' => [[ '11/01', 1], ['11/02', 2]]
}
