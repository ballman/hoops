class ConferenceController < ApplicationController
  def list
    @conferences = Conference.find :all
  end
end
