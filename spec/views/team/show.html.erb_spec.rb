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
    render(:template => 'team/show.html.erb')
  end

  it 'should include a region for an offensive efficiency graph' do
    view.stubs(:team_stats_graph)
    do_render
    rendered.should have_selector('canvas[id=efficiency]')
  end

  it 'should generate an offensive efficiency graph' do
    view.expects(:team_stats_graph)
    do_render
  end
end

