# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def team_link(team)
    link_to team.name, { :controller => 'team', :action => 'show', :id => team.id}, 
      { :class => team.in_64 ? 'in64' : 'non64' }
  end

  def team_mascot_link(team)
    link_to "#{team.name} #{team.mascot}", { :controller => 'team', :action => 'show', :id => team.id},
      { :class => (team.in_64 ? 'non64' : 'in64'), :style => "color: ##{team.color_3} " }
  end

  def game_link(text, game)
    link_to text, { :controller => 'game', :action => 'show', :id => game.id }
  end

  def date_link(date)
    link_to date, { :controller => 'game', :action => 'list', :id => date}
  end

  def stat_header
    result = %{<tr>\n<th class="statheadcell">Team</th>\n}
    for column in TeamAverage.stat_columns do
      result += %{<th class="statheadcell">#{column.humanize}</th>}
    end
    result += "</tr>\n"
  end

  def stat_format(value, col)
    "%0.2f%s" % [(value * (TeamAverage.percent_hash[col] ? 100.0 : 1.0)), TeamAverage.percent_hash[col] ? '%':'']
  end
end
