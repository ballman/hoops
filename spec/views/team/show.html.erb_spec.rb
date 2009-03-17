require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. spec_helper]))

describe 'team/show' do
  before :each do
    @team = assigns[:team] = Team.generate!
    conference = Conference.generate!
    @games = assigns[:games] = []
    @team.stubs(:conference).returns(conference)
    TeamAverage.stubs(:stat_columns).returns([])
    TeamAverage.stubs(:stat_columns).returns([])
  end
  
  def do_render
    render 'team/show'
  end

  it 'should include a region for an offensive efficiency graph' do
    template.stubs(:draw_graph)
    do_render
    response.should have_tag('canvas[id=?]', 'offensive_efficiency')
  end

  it 'should generate an offensive efficiency graph' do
    template.expects(:draw_graph)
    do_render
  end
end

