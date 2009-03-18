module TeamHelper
  def team_stats_graph(team, title, column)
    draw_stats_graph(title,
                     { team.name => team.team_averages.collect(&column).zip(team.team_averages.collect(&:as_of)),
                       '* Opponent' => team.team_foe_averages.collect(&column).zip(team.team_foe_averages.collect(&:as_of).compact.collect {|d| d.strftime("%m/%d") }) },
                     {
                       :minimum_value => "%0.3f" % [ TeamAverage.minimum(column),
                                           TeamFoeAverage.minimum(column)].min,
                       :maximum_value => "%0.3f" % [ TeamAverage.maximum(column),
                                           TeamFoeAverage.maximum(column)].max,
                     }) 

  end
  
  def draw_stats_graph(title, series, options = { })
    # create script with Bluff graph initialization
    result = %Q[<script type="text/javascript">
          var g = new Bluff.Line('offensive_efficiency', 400);
          g.title = '#{title}';\n]

    # set data series
    series.keys.sort.each do |key|
      result << "g.data('#{key}', #{series[key].collect(&:first).inspect});\n"
    end

    # set options
    options.each_pair do |key, value|
      result << "g.#{key} = #{value};\n"
    end

    # draw graph and close script
    result << %Q!g.draw();\n</script>\n!

    result
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
