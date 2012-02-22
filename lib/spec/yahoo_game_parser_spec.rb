require 'yahoo_game_parser'
require 'hpricot'

describe YahooGameParser do
  it 'should be able to create a parser with a html string and a date.' do
    parser = YahooGameParser.new('', Date.today)
  end

  describe 'parsing' do
    before :all do
      @game_html = File.read("yahoo_game_2011.html")
      @parser = YahooGameParser.new(@game_html, Date.today)
    end
    
    before :each do
      @away_code = 'aac'
      @away_name = 'Akron'
      @away_team = Team.create!(:id => 1, :name => "The away team", :yahoo_code => @away_code)
      @home_code = 'mbg'
      @home_name = 'Mississippi St.'
      @home_team = Team.create!(:id => 2, :name => "The home team", :yahoo_code => @home_code)

      @home_scores = [29, 29, 58]
      @away_scores = [37, 31, 68]
      @number_of_away_player_entries = 10
      @number_of_home_player_entries = 8
      @home_team_game = YahooTeamGame.new(:team_id => @home_team.id, :minutes => 200, 
                                          :fgm => 19, :fga => 55,:tpm => 2, :tpa => 13, 
                                          :ftm => 18, :fta => 25, :offense_rebound => 17, 
                                          :total_rebound => 39, :team_rebound => 2, 
                                          :assist => 5, :steal => 4, :block => 5, 
                                          :turnover => 19, :team_turnover => 0, :foul => 12,
                                          :half1_point => 29, :half2_point => 29,
                                          :total_point => 58)
      @away_team_game = YahooTeamGame.new(:team_id => @away_team.id, :minutes => 200, 
                                          :fgm => 30, :fga => 62, :tpm => 2,:tpa => 10, 
                                          :ftm => 6, :fta => 8, :offense_rebound => 11,
                                          :total_rebound => 32, :team_rebound => 2,
                                          :assist => 6, :steal => 8, :block => 6, 
                                          :turnover => 15, :team_turnover => 0, :foul => 22,
                                          :half1_point => 37, :half2_point => 31,
                                          :total_point => 68)
      @away_player_game = YahooPlayerGame.new(:minutes => 30, :fgm=> 3, :fga => 7, :tpm => 0,
                                              :tpa => 1, :ftm => 2, :fta => 2,
                                              :offense_rebound => 1, :total_rebound => 6,
                                              :assist => 0, :steal => 1, :block => 1,
                                              :turnover => 2, :foul => 4, :total_point => 8,
                                              :player_name => 'N. Cvetinovic')
      @home_player_game = YahooPlayerGame.new(:minutes => 33, :fgm => 2, :fga => 9, :tpm => 1,
                                              :tpa => 6, :ftm => 8, :fta => 9,
                                              :offense_rebound => 0, :total_rebound => 5,
                                              :assist => 2, :steal => 3, :block => 1,
                                              :turnover => 4, :foul => 4, :total_point => 13,
                                              :player_name => 'D. Bost')
    end

    describe 'get_teams' do
      it 'should have a get_teams method' do
        @parser.get_teams
      end
      
      it 'should find two teams' do
        @parser.get_teams.should have(2).items
      end
      
      it 'should find the correct away team code' do
        @parser.get_teams[0][0].should eql(@away_name)
      end
      
      it 'should find the correct home team code' do
        @parser.get_teams[1][0].should eql(@home_name)
      end
      
    end

    describe 'finding the final scores' do
      it 'should get an array of scores' do
        @parser.final_scores.should be_an_instance_of Array
      end

      it 'should return two scores' do
        @parser.final_scores.should have(2).items
      end

      it 'should find the correct final score for the away team' do
        @parser.away_final_score.should eql(@away_scores[-1])
      end

      it 'should find the correct final score for the home team' do
        @parser.home_final_score.should eql(@home_scores[-1])
      end
    end

    describe 'finding scores per period' do
      it 'should find an array of scores' do
        @parser.scores_by_period.should be_an_instance_of Array
      end

      it 'should find the correct number of total scores for both teams' do
        @parser.scores_by_period.should have(@away_scores.length + @home_scores.length - 2).items
      end

      it 'should find the correct scores for the away teams' do
        @parser.away_scores_by_period.should eql(@away_scores[0...-1])
      end

      it 'should find the correct scores for the home teams' do
        @parser.home_scores_by_period.should eql(@home_scores[0...-1])
      end
    end

    describe 'finding team total lines' do
      it 'should find the html tables as an array' do
        @parser.team_score_tables.should be_an_instance_of Hpricot::Elements
      end

      it 'should find the html tables as an array' do
        @parser.team_score_tables.should have(2).items
      end
      
      it 'should find an array of stats for index 0' do
        @parser.team_total_lines(0).should be_an_instance_of Array
      end

      it 'should find an array of stats for index 1' do
        @parser.team_total_lines(1).should be_an_instance_of Array
      end

      it 'should find correct number of stats for index 0' do
        @parser.team_total_lines(0).should have(20).items
      end

      it 'should find correct number of stats for index 1' do
        @parser.team_total_lines(0).should have(20).items
      end

      it 'should find correct number of stats for the away team' do
        @parser.away_total_line.should have(20).items
      end

      it 'should find correct number of stats for the home team' do
        @parser.home_total_line.should have(20).items
      end
    end

    describe 'finding team rebounds' do
      it 'should find correct number of team rebounds for index 0' do
        @parser.team_rebounds(0).should eql(@away_team_game.team_rebound)
      end

      it 'should find correct number of team rebounds for index 1' do
        @parser.team_rebounds(0).should eql(@away_team_game.team_rebound)
      end

      it 'should find the correct team rebounds for the away team' do
        @parser.away_team_rebound.should eql(@away_team_game.team_rebound)
      end

      it 'should find the correct team rebounds for the home team' do
        @parser.home_team_rebound.should eql(@home_team_game.team_rebound)
      end
    end

    describe 'finding team turnovers' do
      it 'should find the current number of team turnovers for away team' do
        @parser.away_team_turnover.should eql(@away_team_game.team_turnover)
      end

      it 'should find the current number of team turnovers for home team' do
        @parser.home_team_turnover.should eql(@home_team_game.team_turnover)
      end
    end

    describe 'finding player stats' do
      it 'should find correct number of player stats for the away team' do
        @parser.player_stats(0).should have(@number_of_away_player_entries).items
      end

      it 'should find correct number of player stats for the home team' do
        @parser.player_stats(1).should have(@number_of_home_player_entries).items
      end
    end

    describe 'builing team games' do
      it 'should build the correct home team game' do
        @parser.home_team_game(@home_team).should == @home_team_game
      end

      it 'should build the correct away team game' do
        @parser.away_team_game(@away_team).should == @away_team_game
      end
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

