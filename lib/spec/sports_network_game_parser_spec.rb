require 'sports_network_game_parser'
require 'hpricot'

describe SportsNetworkGameParser do
  it 'should be able to create a parser with a html string and a date.' do
    parser = SportsNetworkGameParser.new('', Date.today)
  end

  describe 'parsing' do
    before :all do
      @game_html = File.read("sports_network_game_2009.html")
      @parser = SportsNetworkGameParser.new(@game_html, Date.today)
    end
    
    before :each do
      @away_code = 'FIU'
      @away_team = Team.create!(:id => 1, :name => "The away team", :sn_code => @away_code)
      @home_code = 'North Carolina'
      @home_team = Team.create!(:id => 2, :name => "The home team", :sn_code => @home_code)

      @home_scores = [46, 42, 88]
      @away_scores = [30, 42, 72]
      @number_of_away_player_entries = 12
      @number_of_home_player_entries = 16
      @home_team_game = SportsNetworkTeamGame.new(:minutes => 200, :fgm => 34, :fga => 61,
                                                 :tpm => 4, :tpa => 13, :ftm => 16, :fta => 19,
                                                 :offense_rebound => 12, :total_rebound => 44,
                                                 :team_rebound => 2, :assist => 23,
                                                 :steal => 10, :block => 8,
                                                 :turnover => 26, :team_turnover => 0,
                                                 :foul => 19, :half1_point => 46,
                                                 :half2_point => 42, :total_point => 88)
      @away_team_game = SportsNetworkTeamGame.new(:minutes => 200, :fgm => 25, :fga => 68,
                                                  :tpm => 8, :tpa => 23,
                                                  :ftm => 14, :fta => 17,
                                                  :offense_rebound => 13, :total_rebound => 29,
                                                  :team_rebound => 8, :assist => 15,
                                                  :steal => 14, :block => 2, :turnover => 20,
                                                  :team_turnover => 0, :foul => 18,
                                                  :half1_point => 30, :half2_point => 42,
                                                  :total_point => 72)
      @home_player_game = SportsNetworkPlayerGame.new(:minutes => 23, :fgm=> 5, :fga => 8,
                                                      :tpm => 0, :tpa => 0,
                                                      :ftm => 3, :fta => 3,
                                                      :offense_rebound => 1,
                                                      :total_rebound => 11, :assist => 2,
                                                      :steal => 1, :block => 4,
                                                      :turnover => 4, :foul => 2,
                                                      :total_point => 13,
                                                      :player_name => 'Ed Davis')
      @away_player_game = SportsNetworkPlayerGame.new(:minutes => 33, :fgm => 5, :fga => 14,
                                                      :tpm => 2, :tpa => 5, :ftm => 4,
                                                      :fta => 5, :offense_rebound => 1,
                                                      :total_rebound => 4, :assist => 6,
                                                      :steal => 1, :block => 1,
                                                      :turnover => 6, :foul => 2,
                                                      :total_point => 16,
                                                      :player_name => 'Antoine Watson')
    end

    describe 'finding score lines' do
      it 'should have a score_lines method' do
        @parser.score_lines
      end

      it 'should return an array' do
        @parser.score_lines.should be_an_instance_of Array
      end

      it 'should return something containing 2 elements' do
        @parser.score_lines.should have(2).items
      end

      it 'should have the find the away team code in the score line' do
        @parser.score_lines[0][0].should eql(@away_code)
      end

      it 'should have the find the home team code in the score line' do
        @parser.score_lines[1][0].should eql(@home_code)
      end
    end

    describe 'get_teams' do
      it 'should have a get_teams method' do
        @parser.get_teams
      end

      it 'should find two teams' do
        @parser.get_teams.should have(2).items
      end

      it 'should find the correct away team code' do
        @parser.get_teams[0][0].should eql(@away_code)
      end

      it 'should find the correct home team code' do
        @parser.get_teams[1][0].should eql(@home_code)
      end

    end


    describe 'finding the final scores' do
      it 'should have the correct final score for the home team' do
        @parser.home_final_score.should eql(@home_scores[-1])
      end

      it 'should have the correct final score for the away team' do
        @parser.away_final_score.should eql(@away_scores[-1])
      end
    end
    
    it 'should find the correct home team scores by period' do
      @parser.home_scores_by_period.should eql(@home_scores[0...-1])
    end

    it 'should find the correct away team scores by period' do
      @parser.away_scores_by_period.should eql(@away_scores[0...-1])
    end

    it 'should find the correct home team rebounds' do
      @parser.home_team_rebound.should eql(@home_team_game.team_rebound)
    end

    it 'should find the correct away team rebounds' do
      @parser.away_team_rebound.should eql(@away_team_game.team_rebound)
    end

    it 'should find the correct home team turnovers' do
      @parser.home_team_turnover.should eql(@home_team_game.team_turnover)
    end

    it 'should find the correct away team turnovers' do
      @parser.away_team_turnover.should eql(@away_team_game.team_turnover)
    end

    it 'should build the correct home team game' do
      @parser.home_team_game(@home_team).should eql(@home_team_game)
    end

    it 'should build the correct away team game' do
      @parser.away_team_game(@away_team).should eql(@away_team_game)
    end

    describe 'building player games' do
      it 'should return an array' do
        @parser.build_player_games(0).should be_an_instance_of Array
      end
    end

    it 'should find the correct number of away player game entries' do
      @parser.build_player_games(0).should have(@number_of_away_player_entries).items
    end

    it 'should find the correct number of home player game entries' do
      @parser.build_player_games(1).should have(@number_of_home_player_entries).items
    end

    it 'should contain the away player game' do
      @parser.build_player_games(0).should include(@away_player_game)
    end

    it 'should contain the home player game' do
      @parser.build_player_games(1).should include(@home_player_game)
    end
  end
end
