require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe TeamHelper do
  it 'should provide a means of drawing a graph' do
    helper.should respond_to(:draw_graph)
  end
  
  describe 'when drawing a graph' do
    it 'should allow graph parameters' do
      lambda { helper.draw_graph(:params)}.should_not raise_error(ArgumentError)
    end
    
    it 'should require graph parameters' do
      lambda { helper.draw_graph }.should raise_error(ArgumentError)
    end
    
    it 'should return a javascript string' do
      helper.draw_graph(:params).should match(%r{<script})
    end
  end
end
