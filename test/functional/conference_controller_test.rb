require File.dirname(__FILE__) + '/../test_helper'
require 'conference_controller'

# Re-raise errors caught by the controller.
class ConferenceController; def rescue_action(e) raise e end; end

class ConferenceControllerTest < Test::Unit::TestCase
  def setup
    @controller = ConferenceController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
