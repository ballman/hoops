require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. spec_helper]))

describe TeamController, "#route_for" do
  it "should generate params { :controller => 'team', action => 'tourney' } from GET /" do
    params_from(:get, "/").should == {:controller => "team", :action => "tourney" }
  end
end
