require File.dirname(__FILE__) + '/../test_helper'
require 'team_stats_controller'

# Re-raise errors caught by the controller.
class TeamStatsController; def rescue_action(e) raise e end; end

class TeamStatsControllerTest < Test::Unit::TestCase
  def setup
    @controller = TeamStatsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
