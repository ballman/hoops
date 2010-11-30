module GameHelper
  def stats_row(stats, klass=nil)
    "<td class='#{klass}'>#{stats.minutes}</td> " +
      "<td class='#{klass}' style='width: 3em;'>#{stats.fgm}-#{stats.fga}</td>\n" +
      "<td class='#{klass}' style='width: 3em;'>#{stats.ftm}-#{stats.fta}</td>\n" +
      "<td class='#{klass}' style='width: 3em;'>#{stats.tpm}-#{stats.tpa}</td>\n" +
      "<td class='#{klass}' style='width: 2em;'>#{stats.offense_rebound}</td>\n" +
      "<td class='#{klass}' style='width: 2em;'>#{stats.total_rebound}</td>\n" +
      "<td class='#{klass}' style='width: 2em;'>#{stats.assist}</td>\n" +
      "<td class='#{klass}' style='width: 2em;'>#{stats.steal}</td>\n" +
      "<td class='#{klass}' style='width: 2em;'>#{stats.block}</td>\n" +
      "<td class='#{klass}' style='width: 2em;'>#{stats.turnover}</td>\n" +
      "<td class='#{klass}' style='width: 2em;'>#{stats.foul}</td>\n" +
      "<td class='#{klass}' style='width: 2em;'>#{stats.total_point}</td>"
  end

  def editable_stats_row(stats, row_id, klass=nil)
    editable_team_game_td(stats, "minutes", row_id, 2, klass) +
      "<td class='#{klass}' style='width: 3em;'>" +
      editable_team_game_stat(stats, "fgm", row_id) + "-" +
      editable_team_game_stat(stats, "fga", row_id) + "</td>" +
      "<td class='#{klass}' style='width: 3em;'>" +
      editable_team_game_stat(stats, "ftm", row_id) + "-" +
      editable_team_game_stat(stats, "fta", row_id) + "</td>" +
      "<td class='#{klass}' style='width: 3em;'>" +
      editable_team_game_stat(stats, "tpm", row_id) + "-" +
      editable_team_game_stat(stats, "tpa", row_id) + "</td>" +
      editable_team_game_td(stats, "offense_rebound", row_id, 2, klass) +
      editable_team_game_td(stats, "total_rebound", row_id, 2, klass) +
      editable_team_game_td(stats, "assist", row_id, 2, klass) +
      editable_team_game_td(stats, "steal", row_id, 2, klass) +
      editable_team_game_td(stats, "block", row_id, 2, klass) +
      editable_team_game_td(stats, "turnover", row_id, 2, klass) +
      editable_team_game_td(stats, "foul", row_id, 2, klass) +
      editable_team_game_td(stats, "total_point", row_id, 2, klass) 
  end

  def stats_header
    stats= %w(Name min fgs fts 3pt off tot ast stl blk tvr fls pts)
    ("<tr>\n<th colspan='5'>&nbsp;</th>\n<th colspan='2'>Rebounds</th>\n" +
      "<th colspan='6'>&nbsp;</th>\n</tr>\n" +
      "<tr><th>" +
      stats.join("</th>\n<th>") +
      "</th></tr>\n").html_safe
  end

  def split_stats_header
    stats= %w(Name min fgm fga ftm fta 3pm 3pa off tot ast stl blk tvr fls pts)
    "<tr>\n<th colspan='8'>&nbsp;</th>\n<th colspan='2'>Rebounds</th>\n" +
      "<th colspan='6'>&nbsp;</th>\n</tr>\n" +
      "<tr><th>" +
      stats.join("</th>\n<th>") +
      "</th></tr>\n"
  end

  def team_box(team_game, edit_player_line_flag)
    str = "<table>\n" +
      team_box_header(team_game.team) +
      stats_header +
      players_boxes(team_game.player_games, edit_player_line_flag) +
      "<tr>\n<td class='total'>TOTALS</td>\n" +
      stats_row(team_game, "total") +
      "\n</tr>\n" +
      "<tr ><td class='total' colspan='3'>&nbsp;</td>\n" +
      "<td class='total' colspan='5'>Team Rebounds: #{team_game.team_rebound}</td>\n"+
      "<td class='total' colspan='5'>Team Turnovers: #{team_game.team_turnover}</td>\n" +
      "</tr>\n</table>\n"
    str.html_safe
  end

  def editable_team_box(team_game, edit_player_line_flag)
    ("<table>\n" +
      team_box_header(team_game.team) +
      stats_header +
      players_boxes(team_game.player_games, edit_player_line_flag) +
      "<tr>\n<td class='total'>TOTALS</td>\n" +
      editable_stats_row(team_game, team_game.id, "total") + "\n</tr>\n" +
      "<tr ><td class='total' style='text-align: left;' colspan='3'>" +
      link_to("Add player game",
              {:controller => "game", :action     => "add_player_game",
                :id         => team_game.id}
              ) +
      "</td>\n" +
      "<td class='total' colspan='5'>Team Rebounds: " +
      editable_team_game_stat(team_game, "team_rebound", team_game.id) +
      "</td>\n"+
      "<td class='total' colspan='5'>Team Turnovers: " +
      editable_team_game_stat(team_game, "team_turnover", team_game.id) +
      "</td>\n" +
      "</tr>\n</table>\n").html_safe
  end

  def master_edit_box(team_game)
    number_of_ots = team_game.game.get_number_of_overtimes
    "<table>\n" +
      team_box_header(team_game.team) +
      split_stats_header +
      player_diff_boxes(team_game.player_games) +
      "</table>\n<br />\n<table>\n" +
      master_total_line_header(number_of_ots) +
      team_game.game.team_games_for_team(team_game.team).inject("")  do |s, tg|
          s += editable_total_line(tg, team_game, number_of_ots)
      end + "</table>\n"
  end

  def all_team_totals(game, team)
    stats = [MasterTeamGame, FoxTeamGame, CstvTeamGame, SportsNetworkTeamGame].collect do |type|
      team_game = game.team_game_for_team_and_type(team, type)
      "<tr><td>#{type}</td>" + stats_row(team_game) + "\n</tr>\n"
    end

    "<table>\n" +
      team_box_header(team) +
      stats_header +
      stats.to_s +
      "</table>\n"
  end

  def master_total_line_header(ots)
    cols = %w(Name min fgm fga ftm fta 3pm 3pa off tot Tm ast stl blk tot
              Tm fls tot 1st 2nd) + (1..ots).to_a.map { |i| "OT#{i}" }
    "<tr>\n<th colspan='8'>&nbsp;</th>\n<th colspan='3'>Rebounds</th>\n" +
      "<th colspan='3'>&nbsp;</th>" +
      "<th colspan='2'>Turnovers</th><th>&nbsp;</th>\n" +
      "<th colspan='<#{(ots + 3).to_s}'>Points</th></tr>\n" +
      "<tr><th>" +
      cols.join("</th>\n<th>") +
      "</th></tr>\n"
  end

  def master_cols(ots)
    %w(minutes fgm fga ftm fta tpm tpa offense_rebound total_rebound
              team_rebound assist steal block turnover team_turnover foul
              total_point half1_point half2_point) +
      (1..ots).to_a.map { |x| "ot#{x}_point" }
  end

  def editable_total_line(stats, master, ots)
    sprintf("<tr id=\"%s\">",
            (stats.class == MasterTeamGame) ? 'masterTotalLine': '') +

      "<td>#{stats.type.to_s.sub(/TeamGame$/,'')}</td>\n" +
      master_cols(ots).map do |col|
        if (stats.class == MasterTeamGame)
          editable_team_game_td(stats, col, stats.id)
        else
          stat_td(2, spanner(stats.send(col),
                             different_highlight(stats.send(col),
                                                 master.send(col))))
        end

      end.join("\n") +
      "</tr>"
  end

  def edit_team_game_script(ots, team_game)
    master_cols(ots).inject("".html_safe) do |str, col|
      str += "new Ajax.InPlaceEditor('team_game_edit_#{col}_#{team_game.id}', '/game/update_master', {cols: 3, cancelLink: false, okButton: false, formClassName: 'team_total_edit_field'});\n"
    end
  end

  def editable_team_game_stat(stats, col, id)
    "<span id='team_game_edit_#{col}_#{id}' class='editable'>#{stats.send(col)}</span>".html_safe
  end
  
  def editable_team_game_td(stats, col, team_game_id, width=2, klass=nil)
    stat_td(width, editable_team_game_stat(stats, col, team_game_id), klass)
  end

  def stat_td(width, stat, klass=nil)
    sprintf("<td %s style=\"width: %dem;\">%s</td>",
            (klass) ? "class=#{klass} " : "", width, stat)
  end

  def spanner(x, style_class)
    "<span class=\"#{style_class}\">#{x}</span>"
  end

  def different_highlight(x, y)
    style = (x == y) ? '' : 'difference'
  end

  private
  def team_box_header(team)
    ("<caption style='background: \##{team.color_1}; color: \##{team.color_3}; colspan='13'>\n" +
      link_to("#{team.name} #{team.mascot}", { :controller => 'player', :action => 'list', :id => team.id}, { :class => (team.in_64 ? 'non64' : 'in64'), :style => "color: ##{team.color_3} " }))
  end

  def players_boxes(player_games, edit_flag, use_type=false)
    out = ""
    player_games.sort { |a,b| a.id <=> b.id}.each do | player_game|
      out += "<tr id='" + cycle("row_0", "row_1") + "'>\n"
      out += "<td style='width: 150px; text-align: left;'>"
      if (edit_flag)
        if (use_type)
          out += edit_player_line(player_game, player_game.class.to_s)
        else
          out += edit_player_line(player_game)
        end
      else
        out += "#{player_game.player.last_name}, #{player_game.player.first_name}</td>\n"
      end
      out += stats_row(player_game)
      out += "\n</tr>"
    end
    return out
  end

  def player_diff_boxes(player_games)
    out = ''
    players = player_games[0].team_game.game.player_games_for_team(player_games[0].team_game.team)
    players.map! { | pg | pg.player }
    players.uniq!
    player_games.sort { |a,b| a.id <=> b.id}.each do | player_game|
      out += "<tr id='" + cycle("row_0", "row_1") + "'>\n"
      out += "<td style='width: 150px; text-align: left;'>"
      out += link_to("#{player_game.player.last_name},#{player_game.player.first_name}",  { :controller => 'game', :action => 'player_diff', :id => player_game.team_game.id, :player => player_game.player_id})
      out += "</td>\n"
      out += player_diff_line(player_game.team_game.game.player_games_for_player(player_game.player))
      out += "\n</tr>"
      players.reject! { | player | player == player_game.player }
    end
    players.each { |player| out += missing_player(player) }
    out
  end

  def player_diff_line(player_games)
    master = player_games.find { |pg| pg.class == MasterPlayerGame }
    cols = %w(minutes fgm fga ftm fta tpm tpa offense_rebound total_rebound
              assist steal block turnover foul total_point)
    cols.map do |c|
      stat_td(2, master.send(c),
                     (player_stat_diff?(c, player_games, master) ? 'difference' : ''))
    end.join("\n")
  end

  def player_games_for_game(player_games)
    player_games.sort {|x,y| y.id<=>x.id}.inject("") do |out, pg|
      out += "<tr id='" + cycle("row_0", "row_1") + "'>\n"
      out += "<td style='width: 150px; text-align: left;'>"
      out += pg.class.to_s
      out += "</td>\n"
      out += stats_row(pg)
      out += "\n</tr>"
    end
  end

  def missing_player(player)
    cols = %w(minutes fgm fga ftm fta tpm tpa offense_rebound total_rebound
              assist steal block turnover foul total_point)
    "<tr>\n" +
      "<td style='width: 150px; text-align: left;'>" +
      "#{player.last_name}, #{player.first_name}</td>\n" +
    cols.map! do |c|
      stat_td(2, '?', 'difference')
    end.join(" ")
  end

  def player_stat_diff?(stat, player_games, master)
    player_games.inject(false) do | result, pg |
      result ||= (pg.send(stat) != master.send(stat))
    end
  end

  def edit_player_line(player_game, link_text=nil)
    out = ""
    link_text ||= player_game.player.last_name + ', ' + player_game.player.first_name
    out += link_to(link_text,
                   { :controller => "game",
                     :action     => "move_player_line_into_edit",
                     :id         => player_game.id
                   },
                   :remote => true)
  end

end
