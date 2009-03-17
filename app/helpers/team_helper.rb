module TeamHelper
  def draw_graph(params)
    %Q#
     <script type="text/javascript">
          var g = new Bluff.Line('offensive_efficiency', 400);
          g.title = 'Efficiency';
          g.data('Offensive', [1, 2, 3, 4, 4, 3]);
          g.data('Defensive', [5, 3, 4, 2, 1, 3, 5, 1, 2, 4 ]);
          g.labels = {0: '11/1', 1:'11/2', 2:'11/3', 3:'11/4'};
          g.draw();
    </script>
    #
  end
  
  def team_breakdown_row(team_game)
    return_string = "<tr><td class='team' style='width: 17em;'>#{team_link(team_game.team)}</td>"
    return_string += breakdown_stats.collect do | stat |
      precision = (percentage_stat.include?(stat)) ? 3 : 0
      "<td class='team'>#{number_with_precision(team_game.send(stat),  precision)}</td>"
    end.join("\n")
    return_string += "</tr>"
  end

  def team_breakdown_diff_row(team_game, average, label)
    return_string = "<tr><td class='diff'>#{label}</td>"
    return_string += breakdown_stats.collect do | stat |
      precision = (percentage_stat.include?(stat)) ? 3 : 1
      negative = (team_game.send(stat) - average.send(stat) < 0) ?  "negative" : ""
      "<td class='diff#{negative}'>#{number_with_precision(team_game.send(stat) - average.send(stat),  precision)}</td>"
    end.join("\n")
  end

  def breakdown_stats
    %w(fgm fga fgp tpm tpa tpp ftm fta ftp offense_rebound total_rebound 
       assist steal block turnover foul total_point)
  end

  def percentage_stat
    %w(fgp tpp ftp)
  end
end
