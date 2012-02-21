require 'yahoo_game_parser'
require 'hpricot'

describe YahooGameParser do
  it 'should be able to create a parser with a html string and a date.' do
    parser = YahooGameParser.new('', Date.today)
  end

  describe 'parsing' do
    before :all do
      @game_html = File.read("yahoo_game_2009.html")
      @parser = YahooGameParser.new(@game_html, Date.today)
    end
    
    before :each do
      @away_code = 'fam'
      @away_name = 'Florida Intl.'
      @away_team = Team.create!(:id => 1, :name => "The away team", :yahoo_code => @away_code)
      @home_code = 'nav'
      @home_name = 'North Carolina'
      @home_team = Team.create!(:id => 2, :name => "The home team", :yahoo_code => @home_code)

      @home_scores = [46, 42, 88]
      @away_scores = [30, 42, 72]
      @number_of_away_player_entries = 11
      @number_of_home_player_entries = 16
      @home_team_game = YahooTeamGame.new(:team_id => @home_team.id, :minutes => 200, :fgm => 34, :fga => 61,
                                          :tpm => 4, :tpa => 13, :ftm => 16, :fta => 19,
                                          :offense_rebound => 11, :total_rebound => 42,
                                          :team_rebound => 2, :assist => 23, :steal => 10,
                                          :block => 8, :turnover => 26, :team_turnover => 0,
                                          :foul => 19, :half1_point => 46, :half2_point => 42,
                                          :total_point => 88)
      @away_team_game = YahooTeamGame.new(:team_id => @away_team.id, :minutes => 200, :fgm => 25, :fga => 68, 
                                          :tpm => 8,:tpa => 23, :ftm => 14, :fta => 17,
                                          :offense_rebound => 9, :total_rebound => 21,
                                          :team_rebound => 8, :assist => 15, :steal => 14,
                                          :block => 2, :turnover => 20, :team_turnover => 0,
                                          :foul => 18, :half1_point => 30, :half2_point => 42,
                                          :total_point => 72)
      @home_player_game = YahooPlayerGame.new(:minutes => 23, :fgm=> 5, :fga => 8, :tpm => 0,
                                              :tpa => 0, :ftm => 3, :fta => 3,
                                              :offense_rebound => 1, :total_rebound => 11,
                                              :assist => 2, :steal => 1, :block => 4,
                                              :turnover => 4, :foul => 2, :total_point => 13,
                                              :player_name => 'E. Davis')
      @away_player_game = YahooPlayerGame.new(:minutes => 33, :fgm => 5, :fga => 14, :tpm => 2,
                                              :tpa => 5, :ftm => 4, :fta => 5,
                                              :offense_rebound => 1, :total_rebound => 4,
                                              :assist => 6, :steal => 1, :block => 1,
                                              :turnover => 6, :foul => 2, :total_point => 16,
                                              :player_name => 'A. Watson')
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
        @parser.team_score_tables.should be_an_instance_of Array
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
        @parser.team_total_lines(0).should have(13).items
      end

      it 'should find correct number of stats for index 1' do
        @parser.team_total_lines(0).should have(13).items
      end

      it 'should find correct number of stats for the away team' do
        @parser.away_total_line.should have(13).items
      end

      it 'should find correct number of stats for the home team' do
        @parser.home_total_line.should have(13).items
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

