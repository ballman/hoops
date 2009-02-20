class YahooPlayerGame < PlayerGame

  def validate_correct_player
    name = player_name
#    name.gsub!(/\./, '') if (name.count('.') == 1)
    name_parts = name.split(/ /)
    name_parts[0].gsub!(/\./, '') if (name_parts[0].count('.') == 1)

    if (match_two_name(name_parts[0], name_parts[1]))
      return
    elsif (name_parts.length == 3 && match_two_name(name_parts[0],
                                                    name_parts[1] + ' ' + name_parts[2]))
      return
    elsif (name_parts.length == 4 && match_two_name(name_parts[0],
                                                    name_parts[1] + ' ' + name_parts[2] + ' ' + name_parts[3]))
      return
    end
    return "#{player_name} does not match #{player.first_name} #{player.last_name}"
  end


  private
  def match_two_name(first_name, last_name)
    (player.first_name[0..first_name.length-1].casecmp(first_name) == 0 &&
     player.last_name[0..last_name.length-1].casecmp(last_name) == 0)
  end

  def match_three_name(first_name, last_name, suffix_name)
    (player.first_name[0..first_name.length-1].casecmp(first_name) == 0 &&
     player.last_name[0..last_name.length-1].casecmp(last_name) == 0 &&
     player.suffix_name[0..suffix_name.length-1].casecmp(suffix_name) == 0)
  end
end
